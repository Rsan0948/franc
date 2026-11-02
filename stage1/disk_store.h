/* FRANCFS1: intentionally small flat disk-backed source store.
 * 12 fixed slots * 4 sectors (2048 bytes). Directory at LBA 129, file data
 * from 136. The boot image occupies sectors 0..127.
 * Disk writes are opt-in: the disk must contain the exact FRANCFS1 header,
 * or the user must explicitly invoke disk-format.
 */
#ifndef FRANC_DISK_STORE_H
#define FRANC_DISK_STORE_H
#define FRANC_FS_SLOTS 12
#define FRANC_FS_LBA_HEADER 128u
#define FRANC_FS_LBA_DIR 129u
#define FRANC_FS_LBA_DATA 136u
#define FRANC_FS_SECTORS_PER_FILE 4u
#define FRANC_FS_SECTOR_SIZE 512u
#define FRANC_FS_SOURCE_LIMIT 2048u
#define FRANC_FS_NAME_LIMIT 24u
#define FRANC_FS_DISK_SECTORS 256u
#ifdef FRANC_BARE_METAL
extern int franc_disk_read_sector(unsigned lba, unsigned char* buf);
extern int franc_disk_write_sector(unsigned lba, const unsigned char* buf);
#else
/* Testing writes only to an explicitly selected image, never a host disk. */
static int franc_host_disk_sector(unsigned lba, unsigned char* buf, int writing) {
    const char* path=getenv("FRANC_DISK_IMAGE");
    if(!path || !*path || lba>=FRANC_FS_DISK_SECTORS)return 0;
    FILE* f=fopen(path,writing?"r+b":"rb");
    if(!f)return 0;
    int ok=fseek(f,(long)lba*512L,SEEK_SET)==0;
    if(ok)ok=(writing?fwrite(buf,1,512,f):fread(buf,1,512,f))==512;
    if(writing && ok)ok=fflush(f)==0;
    fclose(f);return ok;
}
static int franc_disk_read_sector(unsigned lba,unsigned char* out){return franc_host_disk_sector(lba,out,0);}
static int franc_disk_write_sector(unsigned lba,const unsigned char* in){return franc_host_disk_sector(lba,(unsigned char*)in,1);}
#endif
static const unsigned char franc_fs_magic[8]={'F','R','A','N','C','F','S','1'};
static int franc_disk_formatted(void){
    unsigned char sector[512];
    if(!franc_disk_read_sector(FRANC_FS_LBA_HEADER,sector))return 0;
    for(int i=0;i<8;i++)if(sector[i]!=franc_fs_magic[i])return 0;
    return 1;
}
static int franc_disk_format(void){
    unsigned char sector[512]={0};
    if(!franc_disk_read_sector(FRANC_FS_LBA_HEADER,sector))return 0;
    memset(sector,0,sizeof sector);
    memcpy(sector,franc_fs_magic,8);
    if(!franc_disk_write_sector(FRANC_FS_LBA_HEADER,sector))return 0;
    memset(sector,0,sizeof sector);
    return franc_disk_write_sector(FRANC_FS_LBA_DIR,sector);
}
static int franc_disk_dir(unsigned char* sector){
    return franc_disk_formatted() && franc_disk_read_sector(FRANC_FS_LBA_DIR,sector);
}
static int franc_disk_find(const char *name,unsigned char* dir){
    for(int i=0;i<FRANC_FS_SLOTS;i++){
        const unsigned char* e=dir+i*32;
        if(e[0] && strcmp((const char*)e,name)==0)return i;
    }
    return -1;
}
static int franc_disk_save_source(const char* name,const char* source){
    size_t n=strlen(name),len=strlen(source);
    if(!n||n>=FRANC_FS_NAME_LIMIT||len>=FRANC_FS_SOURCE_LIMIT)return 0;
    unsigned char dir[512];if(!franc_disk_dir(dir))return 0;
    int idx=franc_disk_find(name,dir);
    if(idx<0){for(int i=0;i<FRANC_FS_SLOTS;i++)if(!dir[i*32]){idx=i;break;}}
    if(idx<0)return 0;
    unsigned char data[FRANC_FS_SECTOR_SIZE*FRANC_FS_SECTORS_PER_FILE]={0};
    memcpy(data,source,len);
    /* Write file sectors first, then publish directory entry. */
    for(unsigned i=0;i<FRANC_FS_SECTORS_PER_FILE;i++)
        if(!franc_disk_write_sector(FRANC_FS_LBA_DATA+(unsigned)idx*FRANC_FS_SECTORS_PER_FILE+i,
                                   data+i*FRANC_FS_SECTOR_SIZE))return 0;
    unsigned char *e=dir+idx*32;memset(e,0,32);memcpy(e,name,n);
    e[24]=(unsigned char)len;e[25]=(unsigned char)(len>>8);
    return franc_disk_write_sector(FRANC_FS_LBA_DIR,dir);
}
static int franc_disk_load_source(const char* name,char* out){
    unsigned char dir[512];if(!franc_disk_dir(dir))return 0;
    int idx=franc_disk_find(name,dir);if(idx<0)return 0;
    const unsigned char* e=dir+idx*32;
    unsigned len=(unsigned)e[24]|((unsigned)e[25]<<8);
    if(len>=FRANC_FS_SOURCE_LIMIT)return 0;
    unsigned char data[FRANC_FS_SECTOR_SIZE*FRANC_FS_SECTORS_PER_FILE];
    for(unsigned i=0;i<FRANC_FS_SECTORS_PER_FILE;i++)
        if(!franc_disk_read_sector(FRANC_FS_LBA_DATA+(unsigned)idx*FRANC_FS_SECTORS_PER_FILE+i,
                                  data+i*FRANC_FS_SECTOR_SIZE))return 0;
    memcpy(out,data,len);out[len]=0;return 1;
}
#endif
