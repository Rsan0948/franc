.text
.global franc_aot_entry
franc_aot_entry:
.global franc_entry
franc_entry:
  call fw_626f6f74
  ret
fw_61742d77616974:
.comm reg_fw_61742d636f756e74,16,16
  leaq reg_fw_61742d636f756e74(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_61742d69,16,16
  leaq reg_fw_61742d69(%rip), %rdi
  call fr_reg_set
.Lfranc_1:
  leaq reg_fw_61742d69(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_61742d636f756e74(%rip), %rdi
  call fr_reg_get
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_2
  movabsq $503, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_inb
.comm reg_fw_61742d737461747573,16,16
  leaq reg_fw_61742d737461747573(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_61742d737461747573(%rip), %rdi
  call fr_reg_get
  movabsq $255, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_3
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_3:
  leaq reg_fw_61742d737461747573(%rip), %rdi
  call fr_reg_get
  movabsq $128, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_band
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_4
  leaq reg_fw_61742d737461747573(%rip), %rdi
  call fr_reg_get
  movabsq $33, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_band
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_5
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_5:
  leaq reg_fw_61742d737461747573(%rip), %rdi
  call fr_reg_get
  movabsq $8, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_band
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_6
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_6:
.Lfranc_4:
  leaq reg_fw_61742d69(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_61742d69,16,16
  leaq reg_fw_61742d69(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_1
.Lfranc_2:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
fw_6174612d726561642d736563746f72:
.comm reg_fw_61742d6c6261,16,16
  leaq reg_fw_61742d6c6261(%rip), %rdi
  call fr_reg_set
  call fw_68617264776172653f
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_7
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_7:
  leaq reg_fw_61742d6c6261(%rip), %rdi
  call fr_reg_get
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_8
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_8:
  leaq reg_fw_61742d6c6261(%rip), %rdi
  call fr_reg_get
  movabsq $4096, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_9
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  jmp .Lfranc_10
.Lfranc_9:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_10:
.comm reg_fw_61742d626f756e6473,16,16
  leaq reg_fw_61742d626f756e6473(%rip), %rdi
  call fr_reg_set
  movabsq $200000, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_61742d77616974
  call fr_drop
  movabsq $502, %rdi
  movabsq $1, %rsi
  call fr_push
  movabsq $224, %rdi
  movabsq $1, %rsi
  call fr_push
  leaq reg_fw_61742d6c6261(%rip), %rdi
  call fr_reg_get
  movabsq $16777216, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_div
  call fr_floor
  movabsq $15, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_band
  call fr_add
  call fr_outb
  movabsq $498, %rdi
  movabsq $1, %rsi
  call fr_push
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_outb
  movabsq $499, %rdi
  movabsq $1, %rsi
  call fr_push
  leaq reg_fw_61742d6c6261(%rip), %rdi
  call fr_reg_get
  movabsq $255, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_band
  call fr_outb
  movabsq $500, %rdi
  movabsq $1, %rsi
  call fr_push
  leaq reg_fw_61742d6c6261(%rip), %rdi
  call fr_reg_get
  movabsq $256, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_div
  call fr_floor
  movabsq $255, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_band
  call fr_outb
  movabsq $501, %rdi
  movabsq $1, %rsi
  call fr_push
  leaq reg_fw_61742d6c6261(%rip), %rdi
  call fr_reg_get
  movabsq $65536, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_div
  call fr_floor
  movabsq $255, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_band
  call fr_outb
  movabsq $503, %rdi
  movabsq $1, %rsi
  call fr_push
  movabsq $32, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_outb
  movabsq $200000, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_61742d77616974
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_11
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_11:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_61742d69,16,16
  leaq reg_fw_61742d69(%rip), %rdi
  call fr_reg_set
.Lfranc_12:
  leaq reg_fw_61742d69(%rip), %rdi
  call fr_reg_get
  movabsq $256, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_13
  movabsq $496, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_inw
.comm reg_fw_61742d776f7264,16,16
  leaq reg_fw_61742d776f7264(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_61742d69(%rip), %rdi
  call fr_reg_get
  movabsq $2, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_mul
  leaq reg_fw_61742d776f7264(%rip), %rdi
  call fr_reg_get
  movabsq $255, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_band
  call fr_sector_bstore
  leaq reg_fw_61742d69(%rip), %rdi
  call fr_reg_get
  movabsq $2, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_mul
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
  leaq reg_fw_61742d776f7264(%rip), %rdi
  call fr_reg_get
  movabsq $256, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_div
  call fr_floor
  call fr_sector_bstore
  leaq reg_fw_61742d69(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_61742d69,16,16
  leaq reg_fw_61742d69(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_12
.Lfranc_13:
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
fw_6174612d6865616465722d62797465:
  movabsq $128, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_6174612d726561642d736563746f72
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_14
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_14:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sector_bfetch
  ret
fw_6174612d7265616479:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_61722d69,16,16
  leaq reg_fw_61722d69(%rip), %rdi
  call fr_reg_set
.Lfranc_15:
  leaq reg_fw_61722d69(%rip), %rdi
  call fr_reg_get
  movabsq $200000, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_16
  movabsq $503, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_inb
.comm reg_fw_61722d737461747573,16,16
  leaq reg_fw_61722d737461747573(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_61722d737461747573(%rip), %rdi
  call fr_reg_get
  movabsq $255, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_17
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_17:
  leaq reg_fw_61722d737461747573(%rip), %rdi
  call fr_reg_get
  movabsq $128, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_band
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_18
  leaq reg_fw_61722d737461747573(%rip), %rdi
  call fr_reg_get
  movabsq $33, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_band
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_19
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  jmp .Lfranc_20
.Lfranc_19:
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
.Lfranc_20:
  ret
.Lfranc_18:
  leaq reg_fw_61722d69(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_61722d69,16,16
  leaq reg_fw_61722d69(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_15
.Lfranc_16:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
fw_6174612d77726974652d736563746f72:
.comm reg_fw_61772d6c6261,16,16
  leaq reg_fw_61772d6c6261(%rip), %rdi
  call fr_reg_set
  call fw_68617264776172653f
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_21
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_21:
  leaq reg_fw_61772d6c6261(%rip), %rdi
  call fr_reg_get
  movabsq $128, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_22
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_22:
  leaq reg_fw_61772d6c6261(%rip), %rdi
  call fr_reg_get
  movabsq $200, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_23
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_61772d76616c6964,16,16
  leaq reg_fw_61772d76616c6964(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_24
.Lfranc_23:
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_61772d76616c6964,16,16
  leaq reg_fw_61772d76616c6964(%rip), %rdi
  call fr_reg_set
.Lfranc_24:
  leaq reg_fw_61772d76616c6964(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_25
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_25:
  call fw_6174612d7265616479
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_26
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_26:
  movabsq $502, %rdi
  movabsq $1, %rsi
  call fr_push
  movabsq $224, %rdi
  movabsq $1, %rsi
  call fr_push
  leaq reg_fw_61772d6c6261(%rip), %rdi
  call fr_reg_get
  movabsq $16777216, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_div
  call fr_floor
  movabsq $15, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_band
  call fr_add
  call fr_outb
  movabsq $498, %rdi
  movabsq $1, %rsi
  call fr_push
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_outb
  movabsq $499, %rdi
  movabsq $1, %rsi
  call fr_push
  leaq reg_fw_61772d6c6261(%rip), %rdi
  call fr_reg_get
  movabsq $255, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_band
  call fr_outb
  movabsq $500, %rdi
  movabsq $1, %rsi
  call fr_push
  leaq reg_fw_61772d6c6261(%rip), %rdi
  call fr_reg_get
  movabsq $256, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_div
  call fr_floor
  movabsq $255, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_band
  call fr_outb
  movabsq $501, %rdi
  movabsq $1, %rsi
  call fr_push
  leaq reg_fw_61772d6c6261(%rip), %rdi
  call fr_reg_get
  movabsq $65536, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_div
  call fr_floor
  movabsq $255, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_band
  call fr_outb
  movabsq $503, %rdi
  movabsq $1, %rsi
  call fr_push
  movabsq $48, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_outb
  movabsq $200000, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_61742d77616974
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_27
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_27:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_61772d69,16,16
  leaq reg_fw_61772d69(%rip), %rdi
  call fr_reg_set
.Lfranc_28:
  leaq reg_fw_61772d69(%rip), %rdi
  call fr_reg_get
  movabsq $256, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_29
  leaq reg_fw_61772d69(%rip), %rdi
  call fr_reg_get
  movabsq $2, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_mul
  call fr_sector_bfetch
  leaq reg_fw_61772d69(%rip), %rdi
  call fr_reg_get
  movabsq $2, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_mul
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
  call fr_sector_bfetch
  movabsq $256, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_mul
  call fr_add
.comm reg_fw_61772d776f7264,16,16
  leaq reg_fw_61772d776f7264(%rip), %rdi
  call fr_reg_set
  movabsq $496, %rdi
  movabsq $1, %rsi
  call fr_push
  leaq reg_fw_61772d776f7264(%rip), %rdi
  call fr_reg_get
  call fr_outw
  leaq reg_fw_61772d69(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_61772d69,16,16
  leaq reg_fw_61772d69(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_28
.Lfranc_29:
  movabsq $503, %rdi
  movabsq $1, %rsi
  call fr_push
  movabsq $231, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_outb
  call fw_6174612d7265616479
  ret
fw_66732d6c656e:
.comm reg_fw_666c2d61646472,16,16
  leaq reg_fw_666c2d61646472(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_666c2d6e,16,16
  leaq reg_fw_666c2d6e(%rip), %rdi
  call fr_reg_set
.Lfranc_30:
  leaq reg_fw_666c2d6e(%rip), %rdi
  call fr_reg_get
  movabsq $2048, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_31
  leaq reg_fw_666c2d61646472(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_666c2d6e(%rip), %rdi
  call fr_reg_get
  call fr_add
  call fr_bfetch
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_32
  leaq reg_fw_666c2d6e(%rip), %rdi
  call fr_reg_get
  ret
.Lfranc_32:
  leaq reg_fw_666c2d6e(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_666c2d6e,16,16
  leaq reg_fw_666c2d6e(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_30
.Lfranc_31:
  movabsq $2048, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
fw_66732d7a65726f:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_667a2d69,16,16
  leaq reg_fw_667a2d69(%rip), %rdi
  call fr_reg_set
.Lfranc_33:
  leaq reg_fw_667a2d69(%rip), %rdi
  call fr_reg_get
  movabsq $512, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_34
  leaq reg_fw_667a2d69(%rip), %rdi
  call fr_reg_get
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sector_bstore
  leaq reg_fw_667a2d69(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_667a2d69,16,16
  leaq reg_fw_667a2d69(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_33
.Lfranc_34:
  ret
fw_66732d6d616769633f:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_666d2d69,16,16
  leaq reg_fw_666d2d69(%rip), %rdi
  call fr_reg_set
.Lfranc_35:
  leaq reg_fw_666d2d69(%rip), %rdi
  call fr_reg_get
  movabsq $8, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_36
  leaq reg_fw_666d2d69(%rip), %rdi
  call fr_reg_get
  call fr_sector_bfetch
.section .rodata
.Laot_string_37:
  .byte 70
  .byte 82
  .byte 65
  .byte 78
  .byte 67
  .byte 70
  .byte 83
  .byte 49
  .byte 0
.section .text
  leaq .Laot_string_37(%rip), %rdi
  movq $1, %rsi
  call fr_push
  leaq reg_fw_666d2d69(%rip), %rdi
  call fr_reg_get
  call fr_add
  call fr_bfetch
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_38
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_38:
  leaq reg_fw_666d2d69(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_666d2d69,16,16
  leaq reg_fw_666d2d69(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_35
.Lfranc_36:
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
fw_66732d72656164793f:
  call fw_68617264776172653f
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_39
  call fw_6469736b2d72656164793f
  ret
.Lfranc_39:
  movabsq $128, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_6174612d726561642d736563746f72
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_40
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_40:
  call fw_66732d6d616769633f
  ret
fw_66732d666f726d6174:
  call fw_68617264776172653f
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_41
  call fw_6469736b2d666f726d6174
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_41:
  call fw_66732d7a65726f
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_666d2d69,16,16
  leaq reg_fw_666d2d69(%rip), %rdi
  call fr_reg_set
.Lfranc_42:
  leaq reg_fw_666d2d69(%rip), %rdi
  call fr_reg_get
  movabsq $8, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_43
  leaq reg_fw_666d2d69(%rip), %rdi
  call fr_reg_get
.section .rodata
.Laot_string_44:
  .byte 70
  .byte 82
  .byte 65
  .byte 78
  .byte 67
  .byte 70
  .byte 83
  .byte 49
  .byte 0
.section .text
  leaq .Laot_string_44(%rip), %rdi
  movq $1, %rsi
  call fr_push
  leaq reg_fw_666d2d69(%rip), %rdi
  call fr_reg_get
  call fr_add
  call fr_bfetch
  call fr_sector_bstore
  leaq reg_fw_666d2d69(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_666d2d69,16,16
  leaq reg_fw_666d2d69(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_42
.Lfranc_43:
  movabsq $128, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_6174612d77726974652d736563746f72
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_45
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_45:
  call fw_66732d7a65726f
  movabsq $129, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_6174612d77726974652d736563746f72
  ret
fw_66732d6d61746368:
.comm reg_fw_666e2d736c6f74,16,16
  leaq reg_fw_666e2d736c6f74(%rip), %rdi
  call fr_reg_set
.comm reg_fw_666e2d6e616d65,16,16
  leaq reg_fw_666e2d6e616d65(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_666e2d736c6f74(%rip), %rdi
  call fr_reg_get
  movabsq $32, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_mul
.comm reg_fw_666e2d62617365,16,16
  leaq reg_fw_666e2d62617365(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_666e2d69,16,16
  leaq reg_fw_666e2d69(%rip), %rdi
  call fr_reg_set
.Lfranc_46:
  leaq reg_fw_666e2d69(%rip), %rdi
  call fr_reg_get
  movabsq $24, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_47
  leaq reg_fw_666e2d6e616d65(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_666e2d69(%rip), %rdi
  call fr_reg_get
  call fr_add
  call fr_bfetch
.comm reg_fw_666e2d63,16,16
  leaq reg_fw_666e2d63(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_666e2d62617365(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_666e2d69(%rip), %rdi
  call fr_reg_get
  call fr_add
  call fr_sector_bfetch
.comm reg_fw_666e2d64,16,16
  leaq reg_fw_666e2d64(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_666e2d63(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_666e2d64(%rip), %rdi
  call fr_reg_get
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_48
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_48:
  leaq reg_fw_666e2d63(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_49
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_49:
  leaq reg_fw_666e2d69(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_666e2d69,16,16
  leaq reg_fw_666e2d69(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_46
.Lfranc_47:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
fw_66732d66696e64:
.comm reg_fw_66662d6e616d65,16,16
  leaq reg_fw_66662d6e616d65(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_66662d69,16,16
  leaq reg_fw_66662d69(%rip), %rdi
  call fr_reg_set
.Lfranc_50:
  leaq reg_fw_66662d69(%rip), %rdi
  call fr_reg_get
  movabsq $12, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_51
  leaq reg_fw_66662d6e616d65(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_66662d69(%rip), %rdi
  call fr_reg_get
  call fw_66732d6d61746368
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_52
  leaq reg_fw_66662d69(%rip), %rdi
  call fr_reg_get
  ret
.Lfranc_52:
  leaq reg_fw_66662d69(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_66662d69,16,16
  leaq reg_fw_66662d69(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_50
.Lfranc_51:
  movabsq $-1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
fw_66732d66726565:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_66652d69,16,16
  leaq reg_fw_66652d69(%rip), %rdi
  call fr_reg_set
.Lfranc_53:
  leaq reg_fw_66652d69(%rip), %rdi
  call fr_reg_get
  movabsq $12, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_54
  leaq reg_fw_66652d69(%rip), %rdi
  call fr_reg_get
  movabsq $32, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_mul
  call fr_sector_bfetch
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_55
  leaq reg_fw_66652d69(%rip), %rdi
  call fr_reg_get
  ret
.Lfranc_55:
  leaq reg_fw_66652d69(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_66652d69,16,16
  leaq reg_fw_66652d69(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_53
.Lfranc_54:
  movabsq $-1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
fw_66732d73617665:
.comm reg_fw_66732d64617461,16,16
  leaq reg_fw_66732d64617461(%rip), %rdi
  call fr_reg_set
.comm reg_fw_66732d6e616d65,16,16
  leaq reg_fw_66732d6e616d65(%rip), %rdi
  call fr_reg_set
  call fw_68617264776172653f
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_56
  leaq reg_fw_66732d6e616d65(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_66732d64617461(%rip), %rdi
  call fr_reg_get
  call fw_686f73742d73617665
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_56:
  leaq reg_fw_66732d6e616d65(%rip), %rdi
  call fr_reg_get
  call fw_66732d6c656e
.comm reg_fw_66732d6e6c656e,16,16
  leaq reg_fw_66732d6e6c656e(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_66732d64617461(%rip), %rdi
  call fr_reg_get
  call fw_66732d6c656e
.comm reg_fw_66732d646c656e,16,16
  leaq reg_fw_66732d646c656e(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_66732d6e6c656e(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_57
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_57:
  leaq reg_fw_66732d6e6c656e(%rip), %rdi
  call fr_reg_get
  movabsq $24, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_58
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_58:
  leaq reg_fw_66732d6e6c656e(%rip), %rdi
  call fr_reg_get
  movabsq $24, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_59
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_66732d6e2d6f6b,16,16
  leaq reg_fw_66732d6e2d6f6b(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_60
.Lfranc_59:
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_66732d6e2d6f6b,16,16
  leaq reg_fw_66732d6e2d6f6b(%rip), %rdi
  call fr_reg_set
.Lfranc_60:
  leaq reg_fw_66732d6e2d6f6b(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_61
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_61:
  leaq reg_fw_66732d646c656e(%rip), %rdi
  call fr_reg_get
  movabsq $2048, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_62
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_62:
  call fw_66732d72656164793f
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_63
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_63:
  movabsq $129, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_6174612d726561642d736563746f72
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_64
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_64:
  leaq reg_fw_66732d6e616d65(%rip), %rdi
  call fr_reg_get
  call fw_66732d66696e64
.comm reg_fw_66732d736c6f74,16,16
  leaq reg_fw_66732d736c6f74(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_66732d736c6f74(%rip), %rdi
  call fr_reg_get
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_65
  call fw_66732d66726565
.comm reg_fw_66732d736c6f74,16,16
  leaq reg_fw_66732d736c6f74(%rip), %rdi
  call fr_reg_set
.Lfranc_65:
  leaq reg_fw_66732d736c6f74(%rip), %rdi
  call fr_reg_get
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_66
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_66:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_66732d626c6f636b,16,16
  leaq reg_fw_66732d626c6f636b(%rip), %rdi
  call fr_reg_set
.Lfranc_67:
  leaq reg_fw_66732d626c6f636b(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_66732d646c656e(%rip), %rdi
  call fr_reg_get
  movabsq $511, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
  movabsq $512, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_div
  call fr_floor
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_68
  call fw_66732d7a65726f
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_66732d6a,16,16
  leaq reg_fw_66732d6a(%rip), %rdi
  call fr_reg_set
.Lfranc_69:
  leaq reg_fw_66732d6a(%rip), %rdi
  call fr_reg_get
  movabsq $512, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_70
  leaq reg_fw_66732d626c6f636b(%rip), %rdi
  call fr_reg_get
  movabsq $512, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_mul
  leaq reg_fw_66732d6a(%rip), %rdi
  call fr_reg_get
  call fr_add
.comm reg_fw_66732d696e646578,16,16
  leaq reg_fw_66732d696e646578(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_66732d696e646578(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_66732d646c656e(%rip), %rdi
  call fr_reg_get
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_71
  leaq reg_fw_66732d6a(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_66732d64617461(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_66732d696e646578(%rip), %rdi
  call fr_reg_get
  call fr_add
  call fr_bfetch
  call fr_sector_bstore
.Lfranc_71:
  leaq reg_fw_66732d6a(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_66732d6a,16,16
  leaq reg_fw_66732d6a(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_69
.Lfranc_70:
  movabsq $136, %rdi
  movabsq $1, %rsi
  call fr_push
  leaq reg_fw_66732d736c6f74(%rip), %rdi
  call fr_reg_get
  movabsq $4, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_mul
  call fr_add
  leaq reg_fw_66732d626c6f636b(%rip), %rdi
  call fr_reg_get
  call fr_add
  call fw_6174612d77726974652d736563746f72
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_72
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_72:
  leaq reg_fw_66732d626c6f636b(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_66732d626c6f636b,16,16
  leaq reg_fw_66732d626c6f636b(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_67
.Lfranc_68:
  movabsq $129, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_6174612d726561642d736563746f72
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_73
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_73:
  leaq reg_fw_66732d736c6f74(%rip), %rdi
  call fr_reg_get
  movabsq $32, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_mul
.comm reg_fw_66732d62617365,16,16
  leaq reg_fw_66732d62617365(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_66732d6a,16,16
  leaq reg_fw_66732d6a(%rip), %rdi
  call fr_reg_set
.Lfranc_74:
  leaq reg_fw_66732d6a(%rip), %rdi
  call fr_reg_get
  movabsq $32, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_75
  leaq reg_fw_66732d62617365(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_66732d6a(%rip), %rdi
  call fr_reg_get
  call fr_add
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sector_bstore
  leaq reg_fw_66732d6a(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_66732d6a,16,16
  leaq reg_fw_66732d6a(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_74
.Lfranc_75:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_66732d6a,16,16
  leaq reg_fw_66732d6a(%rip), %rdi
  call fr_reg_set
.Lfranc_76:
  leaq reg_fw_66732d6a(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_66732d6e6c656e(%rip), %rdi
  call fr_reg_get
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_77
  leaq reg_fw_66732d62617365(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_66732d6a(%rip), %rdi
  call fr_reg_get
  call fr_add
  leaq reg_fw_66732d6e616d65(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_66732d6a(%rip), %rdi
  call fr_reg_get
  call fr_add
  call fr_bfetch
  call fr_sector_bstore
  leaq reg_fw_66732d6a(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_66732d6a,16,16
  leaq reg_fw_66732d6a(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_76
.Lfranc_77:
  leaq reg_fw_66732d62617365(%rip), %rdi
  call fr_reg_get
  movabsq $24, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
  leaq reg_fw_66732d646c656e(%rip), %rdi
  call fr_reg_get
  movabsq $256, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_mod
  call fr_sector_bstore
  leaq reg_fw_66732d62617365(%rip), %rdi
  call fr_reg_get
  movabsq $25, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
  leaq reg_fw_66732d646c656e(%rip), %rdi
  call fr_reg_get
  movabsq $256, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_div
  call fr_floor
  call fr_sector_bstore
  movabsq $129, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_6174612d77726974652d736563746f72
  ret
fw_66732d736f75726365:
.comm reg_fw_6673722d6e616d65,16,16
  leaq reg_fw_6673722d6e616d65(%rip), %rdi
  call fr_reg_set
  call fw_68617264776172653f
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_78
  leaq reg_fw_6673722d6e616d65(%rip), %rdi
  call fr_reg_get
  call fw_686f73742d736f75726365
  ret
.Lfranc_78:
  call fw_66732d72656164793f
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_79
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_79:
  movabsq $129, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_6174612d726561642d736563746f72
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_80
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_80:
  leaq reg_fw_6673722d6e616d65(%rip), %rdi
  call fr_reg_get
  call fw_66732d66696e64
.comm reg_fw_6673722d736c6f74,16,16
  leaq reg_fw_6673722d736c6f74(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_6673722d736c6f74(%rip), %rdi
  call fr_reg_get
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_81
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_81:
  leaq reg_fw_6673722d736c6f74(%rip), %rdi
  call fr_reg_get
  movabsq $32, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_mul
  movabsq $24, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
  call fr_sector_bfetch
.comm reg_fw_6673722d6c6f,16,16
  leaq reg_fw_6673722d6c6f(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_6673722d736c6f74(%rip), %rdi
  call fr_reg_get
  movabsq $32, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_mul
  movabsq $25, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
  call fr_sector_bfetch
  movabsq $256, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_mul
  leaq reg_fw_6673722d6c6f(%rip), %rdi
  call fr_reg_get
  call fr_add
.comm reg_fw_6673722d6c656e677468,16,16
  leaq reg_fw_6673722d6c656e677468(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_6673722d6c656e677468(%rip), %rdi
  call fr_reg_get
  movabsq $2048, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_82
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_82:
  leaq reg_fw_6673722d6c656e677468(%rip), %rdi
  call fr_reg_get
  movabsq $2048, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_83
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6673722d746f6f2d6c6f6e67,16,16
  leaq reg_fw_6673722d746f6f2d6c6f6e67(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_84
.Lfranc_83:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_84:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6673722d626c6f636b,16,16
  leaq reg_fw_6673722d626c6f636b(%rip), %rdi
  call fr_reg_set
.Lfranc_85:
  leaq reg_fw_6673722d626c6f636b(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_6673722d6c656e677468(%rip), %rdi
  call fr_reg_get
  movabsq $511, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
  movabsq $512, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_div
  call fr_floor
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_86
  movabsq $136, %rdi
  movabsq $1, %rsi
  call fr_push
  leaq reg_fw_6673722d736c6f74(%rip), %rdi
  call fr_reg_get
  movabsq $4, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_mul
  call fr_add
  leaq reg_fw_6673722d626c6f636b(%rip), %rdi
  call fr_reg_get
  call fr_add
  call fw_6174612d726561642d736563746f72
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_87
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_87:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6673722d69,16,16
  leaq reg_fw_6673722d69(%rip), %rdi
  call fr_reg_set
.Lfranc_88:
  leaq reg_fw_6673722d69(%rip), %rdi
  call fr_reg_get
  movabsq $512, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_89
  leaq reg_fw_6673722d626c6f636b(%rip), %rdi
  call fr_reg_get
  movabsq $512, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_mul
  leaq reg_fw_6673722d69(%rip), %rdi
  call fr_reg_get
  call fr_add
.comm reg_fw_6673722d696e646578,16,16
  leaq reg_fw_6673722d696e646578(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_6673722d696e646578(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_6673722d6c656e677468(%rip), %rdi
  call fr_reg_get
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_90
  leaq reg_fw_6673722d696e646578(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_6673722d69(%rip), %rdi
  call fr_reg_get
  call fr_sector_bfetch
  call fr_source_bstore
.Lfranc_90:
  leaq reg_fw_6673722d69(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_6673722d69,16,16
  leaq reg_fw_6673722d69(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_88
.Lfranc_89:
  leaq reg_fw_6673722d626c6f636b(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_6673722d626c6f636b,16,16
  leaq reg_fw_6673722d626c6f636b(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_85
.Lfranc_86:
  leaq reg_fw_6673722d6c656e677468(%rip), %rdi
  call fr_reg_get
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_source_bstore
  call fr_source_buffer
  ret
fw_66732d66696c6573:
  call fw_68617264776172653f
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_91
  call fw_686f73742d66696c6573
  ret
.Lfranc_91:
  call fw_66732d72656164793f
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_92
  ret
.Lfranc_92:
  movabsq $129, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_6174612d726561642d736563746f72
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_93
  ret
.Lfranc_93:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6666732d69,16,16
  leaq reg_fw_6666732d69(%rip), %rdi
  call fr_reg_set
.Lfranc_94:
  leaq reg_fw_6666732d69(%rip), %rdi
  call fr_reg_get
  movabsq $12, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_95
  leaq reg_fw_6666732d69(%rip), %rdi
  call fr_reg_get
  movabsq $32, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_mul
  call fr_sector_bfetch
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_96
  call fr_sector_buf
  leaq reg_fw_6666732d69(%rip), %rdi
  call fr_reg_get
  movabsq $32, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_mul
  call fr_add
  call fr_type
  movabsq $10, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_emit
.Lfranc_96:
  leaq reg_fw_6666732d69(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_6666732d69,16,16
  leaq reg_fw_6666732d69(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_94
.Lfranc_95:
  ret
fw_736f75726365:
  call fw_66732d736f75726365
  ret
fw_73617665:
  call fw_66732d73617665
  call fr_drop
  ret
fw_66696c6573:
  call fw_66732d66696c6573
  ret
fw_76632d696e6974:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_76632d636f6c,16,16
  leaq reg_fw_76632d636f6c(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_76632d726f77,16,16
  leaq reg_fw_76632d726f77(%rip), %rdi
  call fr_reg_set
  ret
fw_76632d706978656c:
.comm reg_fw_76632d696e6b,16,16
  leaq reg_fw_76632d696e6b(%rip), %rdi
  call fr_reg_set
.comm reg_fw_76632d7079,16,16
  leaq reg_fw_76632d7079(%rip), %rdi
  call fr_reg_set
.comm reg_fw_76632d7078,16,16
  leaq reg_fw_76632d7078(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_76632d7078(%rip), %rdi
  call fr_reg_get
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_97
  ret
.Lfranc_97:
  leaq reg_fw_76632d7079(%rip), %rdi
  call fr_reg_get
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_98
  ret
.Lfranc_98:
  leaq reg_fw_76632d7078(%rip), %rdi
  call fr_reg_get
  movabsq $320, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_99
  ret
.Lfranc_99:
  leaq reg_fw_76632d7079(%rip), %rdi
  call fr_reg_get
  movabsq $200, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_100
  ret
.Lfranc_100:
  leaq reg_fw_76632d7078(%rip), %rdi
  call fr_reg_get
  movabsq $320, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_101
  leaq reg_fw_76632d7079(%rip), %rdi
  call fr_reg_get
  movabsq $200, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_102
  movabsq $655360, %rdi
  movabsq $1, %rsi
  call fr_push
  leaq reg_fw_76632d7079(%rip), %rdi
  call fr_reg_get
  movabsq $320, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_mul
  call fr_add
  leaq reg_fw_76632d7078(%rip), %rdi
  call fr_reg_get
  call fr_add
  leaq reg_fw_76632d696e6b(%rip), %rdi
  call fr_reg_get
  call fr_bstore
.Lfranc_102:
.Lfranc_101:
  ret
fw_76632d636c656172:
.comm reg_fw_76632d6267,16,16
  leaq reg_fw_76632d6267(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_76632d6369,16,16
  leaq reg_fw_76632d6369(%rip), %rdi
  call fr_reg_set
.Lfranc_103:
  leaq reg_fw_76632d6369(%rip), %rdi
  call fr_reg_get
  movabsq $64000, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_104
  movabsq $655360, %rdi
  movabsq $1, %rsi
  call fr_push
  leaq reg_fw_76632d6369(%rip), %rdi
  call fr_reg_get
  call fr_add
  leaq reg_fw_76632d6267(%rip), %rdi
  call fr_reg_get
  call fr_bstore
  leaq reg_fw_76632d6369(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_76632d6369,16,16
  leaq reg_fw_76632d6369(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_103
.Lfranc_104:
  ret
fw_76632d676c797068:
.comm reg_fw_76672d6368,16,16
  leaq reg_fw_76672d6368(%rip), %rdi
  call fr_reg_set
.comm reg_fw_76672d78,16,16
  leaq reg_fw_76672d78(%rip), %rdi
  call fr_reg_set
.comm reg_fw_76672d79,16,16
  leaq reg_fw_76672d79(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_76672d6779,16,16
  leaq reg_fw_76672d6779(%rip), %rdi
  call fr_reg_set
.Lfranc_105:
  leaq reg_fw_76672d6779(%rip), %rdi
  call fr_reg_get
  movabsq $8, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_106
  call fr_font_base
  leaq reg_fw_76672d6368(%rip), %rdi
  call fr_reg_get
  movabsq $8, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_mul
  call fr_add
  leaq reg_fw_76672d6779(%rip), %rdi
  call fr_reg_get
  call fr_add
  call fr_bfetch
.comm reg_fw_76672d62697473,16,16
  leaq reg_fw_76672d62697473(%rip), %rdi
  call fr_reg_set
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_76672d6d61736b,16,16
  leaq reg_fw_76672d6d61736b(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_76672d6778,16,16
  leaq reg_fw_76672d6778(%rip), %rdi
  call fr_reg_set
.Lfranc_107:
  leaq reg_fw_76672d6778(%rip), %rdi
  call fr_reg_get
  movabsq $8, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_108
  leaq reg_fw_76672d62697473(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_76672d6d61736b(%rip), %rdi
  call fr_reg_get
  call fr_band
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_109
  movabsq $15, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_76672d696e6b,16,16
  leaq reg_fw_76672d696e6b(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_110
.Lfranc_109:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_76672d696e6b,16,16
  leaq reg_fw_76672d696e6b(%rip), %rdi
  call fr_reg_set
.Lfranc_110:
  leaq reg_fw_76672d78(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_76672d6778(%rip), %rdi
  call fr_reg_get
  call fr_add
  leaq reg_fw_76672d79(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_76672d6779(%rip), %rdi
  call fr_reg_get
  call fr_add
  leaq reg_fw_76672d696e6b(%rip), %rdi
  call fr_reg_get
  call fw_76632d706978656c
  leaq reg_fw_76672d6d61736b(%rip), %rdi
  call fr_reg_get
  movabsq $2, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_mul
.comm reg_fw_76672d6d61736b,16,16
  leaq reg_fw_76672d6d61736b(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_76672d6778(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_76672d6778,16,16
  leaq reg_fw_76672d6778(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_107
.Lfranc_108:
  leaq reg_fw_76672d6779(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_76672d6779,16,16
  leaq reg_fw_76672d6779(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_105
.Lfranc_106:
  ret
fw_76632d7363726f6c6c:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_76732d69,16,16
  leaq reg_fw_76732d69(%rip), %rdi
  call fr_reg_set
.Lfranc_111:
  leaq reg_fw_76732d69(%rip), %rdi
  call fr_reg_get
  movabsq $61440, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_112
  movabsq $655360, %rdi
  movabsq $1, %rsi
  call fr_push
  leaq reg_fw_76732d69(%rip), %rdi
  call fr_reg_get
  movabsq $2560, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
  call fr_add
  call fr_bfetch
  movabsq $655360, %rdi
  movabsq $1, %rsi
  call fr_push
  leaq reg_fw_76732d69(%rip), %rdi
  call fr_reg_get
  call fr_add
  call fr_swap
  call fr_bstore
  leaq reg_fw_76732d69(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_76732d69,16,16
  leaq reg_fw_76732d69(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_111
.Lfranc_112:
.Lfranc_113:
  leaq reg_fw_76732d69(%rip), %rdi
  call fr_reg_get
  movabsq $64000, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_114
  movabsq $655360, %rdi
  movabsq $1, %rsi
  call fr_push
  leaq reg_fw_76732d69(%rip), %rdi
  call fr_reg_get
  call fr_add
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_bstore
  leaq reg_fw_76732d69(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_76732d69,16,16
  leaq reg_fw_76732d69(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_113
.Lfranc_114:
  ret
fw_76632d7363726f6c6c3f:
  leaq reg_fw_76632d726f77(%rip), %rdi
  call fr_reg_get
  movabsq $25, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_115
  call fw_76632d7363726f6c6c
  movabsq $24, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_76632d726f77,16,16
  leaq reg_fw_76632d726f77(%rip), %rdi
  call fr_reg_set
.Lfranc_115:
  ret
fw_76632d707574:
.comm reg_fw_76632d6368,16,16
  leaq reg_fw_76632d6368(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_76632d6368(%rip), %rdi
  call fr_reg_get
  call fr_emit
  leaq reg_fw_76632d6368(%rip), %rdi
  call fr_reg_get
  movabsq $10, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_116
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_76632d636f6c,16,16
  leaq reg_fw_76632d636f6c(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_76632d726f77(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_76632d726f77,16,16
  leaq reg_fw_76632d726f77(%rip), %rdi
  call fr_reg_set
  call fw_76632d7363726f6c6c3f
  ret
.Lfranc_116:
  leaq reg_fw_76632d6368(%rip), %rdi
  call fr_reg_get
  movabsq $13, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_117
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_76632d636f6c,16,16
  leaq reg_fw_76632d636f6c(%rip), %rdi
  call fr_reg_set
  ret
.Lfranc_117:
  leaq reg_fw_76632d6368(%rip), %rdi
  call fr_reg_get
  movabsq $8, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_118
  leaq reg_fw_76632d636f6c(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_119
  leaq reg_fw_76632d636f6c(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
.comm reg_fw_76632d636f6c,16,16
  leaq reg_fw_76632d636f6c(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_76632d636f6c(%rip), %rdi
  call fr_reg_get
  movabsq $8, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_mul
  leaq reg_fw_76632d726f77(%rip), %rdi
  call fr_reg_get
  movabsq $8, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_mul
  movabsq $32, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_76632d676c797068
.Lfranc_119:
  ret
.Lfranc_118:
  leaq reg_fw_76632d6368(%rip), %rdi
  call fr_reg_get
  movabsq $32, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_120
  movabsq $63, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_76632d6368,16,16
  leaq reg_fw_76632d6368(%rip), %rdi
  call fr_reg_set
.Lfranc_120:
  leaq reg_fw_76632d6368(%rip), %rdi
  call fr_reg_get
  movabsq $127, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_121
  movabsq $63, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_76632d6368,16,16
  leaq reg_fw_76632d6368(%rip), %rdi
  call fr_reg_set
.Lfranc_121:
  leaq reg_fw_76632d6368(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_76632d636f6c(%rip), %rdi
  call fr_reg_get
  movabsq $8, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_mul
  leaq reg_fw_76632d726f77(%rip), %rdi
  call fr_reg_get
  movabsq $8, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_mul
  call fw_76632d676c797068
  leaq reg_fw_76632d636f6c(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_76632d636f6c,16,16
  leaq reg_fw_76632d636f6c(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_76632d636f6c(%rip), %rdi
  call fr_reg_get
  movabsq $40, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_122
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_76632d636f6c,16,16
  leaq reg_fw_76632d636f6c(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_76632d726f77(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_76632d726f77,16,16
  leaq reg_fw_76632d726f77(%rip), %rdi
  call fr_reg_set
  call fw_76632d7363726f6c6c3f
.Lfranc_122:
  ret
fw_76632d74797065:
.comm reg_fw_76742d707472,16,16
  leaq reg_fw_76742d707472(%rip), %rdi
  call fr_reg_set
.Lfranc_123:
  leaq reg_fw_76742d707472(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
.comm reg_fw_76742d6368,16,16
  leaq reg_fw_76742d6368(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_76742d6368(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_124
  ret
.Lfranc_124:
  leaq reg_fw_76742d6368(%rip), %rdi
  call fr_reg_get
  call fw_76632d707574
  leaq reg_fw_76742d707472(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_76742d707472,16,16
  leaq reg_fw_76742d707472(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_123
  ret
fw_76632d686f6d65:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_76632d636f6c,16,16
  leaq reg_fw_76632d636f6c(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_76632d726f77,16,16
  leaq reg_fw_76632d726f77(%rip), %rdi
  call fr_reg_set
  ret
fw_76632d6e65776c696e65:
  movabsq $10, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_76632d707574
  ret
fw_646b2d696e6974:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_646b2d7368696674,16,16
  leaq reg_fw_646b2d7368696674(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_646b2d657874656e646564,16,16
  leaq reg_fw_646b2d657874656e646564(%rip), %rdi
  call fr_reg_set
  ret
fw_646b2d6d6170:
.comm reg_fw_646b2d636f6465,16,16
  leaq reg_fw_646b2d636f6465(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_646b2d636f6465(%rip), %rdi
  call fr_reg_get
  movabsq $2, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_125
  movabsq $49, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_125:
  leaq reg_fw_646b2d636f6465(%rip), %rdi
  call fr_reg_get
  movabsq $2, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_126
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_126:
  leaq reg_fw_646b2d636f6465(%rip), %rdi
  call fr_reg_get
  movabsq $14, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_127
  leaq reg_fw_646b2d7368696674(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_128
.section .rodata
.Laot_string_129:
  .byte 49
  .byte 50
  .byte 51
  .byte 52
  .byte 53
  .byte 54
  .byte 55
  .byte 56
  .byte 57
  .byte 48
  .byte 45
  .byte 61
  .byte 0
.section .text
  leaq .Laot_string_129(%rip), %rdi
  movq $1, %rsi
  call fr_push
  jmp .Lfranc_130
.Lfranc_128:
.section .rodata
.Laot_string_131:
  .byte 33
  .byte 64
  .byte 35
  .byte 36
  .byte 37
  .byte 94
  .byte 38
  .byte 42
  .byte 40
  .byte 41
  .byte 95
  .byte 43
  .byte 0
.section .text
  leaq .Laot_string_131(%rip), %rdi
  movq $1, %rsi
  call fr_push
.Lfranc_130:
  leaq reg_fw_646b2d636f6465(%rip), %rdi
  call fr_reg_get
  movabsq $2, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_add
  call fr_bfetch
  ret
.Lfranc_127:
  leaq reg_fw_646b2d636f6465(%rip), %rdi
  call fr_reg_get
  movabsq $14, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_132
  movabsq $8, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_132:
  leaq reg_fw_646b2d636f6465(%rip), %rdi
  call fr_reg_get
  movabsq $15, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_133
  movabsq $9, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_133:
  leaq reg_fw_646b2d636f6465(%rip), %rdi
  call fr_reg_get
  movabsq $16, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_134
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_134:
  leaq reg_fw_646b2d636f6465(%rip), %rdi
  call fr_reg_get
  movabsq $28, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_135
  leaq reg_fw_646b2d7368696674(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_136
.section .rodata
.Laot_string_137:
  .byte 113
  .byte 119
  .byte 101
  .byte 114
  .byte 116
  .byte 121
  .byte 117
  .byte 105
  .byte 111
  .byte 112
  .byte 91
  .byte 93
  .byte 0
.section .text
  leaq .Laot_string_137(%rip), %rdi
  movq $1, %rsi
  call fr_push
  jmp .Lfranc_138
.Lfranc_136:
.section .rodata
.Laot_string_139:
  .byte 81
  .byte 87
  .byte 69
  .byte 82
  .byte 84
  .byte 89
  .byte 85
  .byte 73
  .byte 79
  .byte 80
  .byte 123
  .byte 125
  .byte 0
.section .text
  leaq .Laot_string_139(%rip), %rdi
  movq $1, %rsi
  call fr_push
.Lfranc_138:
  leaq reg_fw_646b2d636f6465(%rip), %rdi
  call fr_reg_get
  movabsq $16, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_add
  call fr_bfetch
  ret
.Lfranc_135:
  leaq reg_fw_646b2d636f6465(%rip), %rdi
  call fr_reg_get
  movabsq $28, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_140
  movabsq $10, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_140:
  leaq reg_fw_646b2d636f6465(%rip), %rdi
  call fr_reg_get
  movabsq $30, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_141
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_141:
  leaq reg_fw_646b2d636f6465(%rip), %rdi
  call fr_reg_get
  movabsq $39, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_142
  leaq reg_fw_646b2d7368696674(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_143
.section .rodata
.Laot_string_144:
  .byte 97
  .byte 115
  .byte 100
  .byte 102
  .byte 103
  .byte 104
  .byte 106
  .byte 107
  .byte 108
  .byte 0
.section .text
  leaq .Laot_string_144(%rip), %rdi
  movq $1, %rsi
  call fr_push
  jmp .Lfranc_145
.Lfranc_143:
.section .rodata
.Laot_string_146:
  .byte 65
  .byte 83
  .byte 68
  .byte 70
  .byte 71
  .byte 72
  .byte 74
  .byte 75
  .byte 76
  .byte 0
.section .text
  leaq .Laot_string_146(%rip), %rdi
  movq $1, %rsi
  call fr_push
.Lfranc_145:
  leaq reg_fw_646b2d636f6465(%rip), %rdi
  call fr_reg_get
  movabsq $30, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_add
  call fr_bfetch
  ret
.Lfranc_142:
  leaq reg_fw_646b2d636f6465(%rip), %rdi
  call fr_reg_get
  movabsq $39, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_147
  leaq reg_fw_646b2d7368696674(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_148
  movabsq $59, %rdi
  movabsq $1, %rsi
  call fr_push
  jmp .Lfranc_149
.Lfranc_148:
  movabsq $58, %rdi
  movabsq $1, %rsi
  call fr_push
.Lfranc_149:
  ret
.Lfranc_147:
  leaq reg_fw_646b2d636f6465(%rip), %rdi
  call fr_reg_get
  movabsq $40, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_150
  leaq reg_fw_646b2d7368696674(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_151
  movabsq $39, %rdi
  movabsq $1, %rsi
  call fr_push
  jmp .Lfranc_152
.Lfranc_151:
  movabsq $34, %rdi
  movabsq $1, %rsi
  call fr_push
.Lfranc_152:
  ret
.Lfranc_150:
  leaq reg_fw_646b2d636f6465(%rip), %rdi
  call fr_reg_get
  movabsq $41, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_153
  leaq reg_fw_646b2d7368696674(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_154
  movabsq $96, %rdi
  movabsq $1, %rsi
  call fr_push
  jmp .Lfranc_155
.Lfranc_154:
  movabsq $126, %rdi
  movabsq $1, %rsi
  call fr_push
.Lfranc_155:
  ret
.Lfranc_153:
  leaq reg_fw_646b2d636f6465(%rip), %rdi
  call fr_reg_get
  movabsq $43, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_156
  leaq reg_fw_646b2d7368696674(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_157
  movabsq $92, %rdi
  movabsq $1, %rsi
  call fr_push
  jmp .Lfranc_158
.Lfranc_157:
  movabsq $124, %rdi
  movabsq $1, %rsi
  call fr_push
.Lfranc_158:
  ret
.Lfranc_156:
  leaq reg_fw_646b2d636f6465(%rip), %rdi
  call fr_reg_get
  movabsq $44, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_159
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_159:
  leaq reg_fw_646b2d636f6465(%rip), %rdi
  call fr_reg_get
  movabsq $54, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_160
  leaq reg_fw_646b2d7368696674(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_161
.section .rodata
.Laot_string_162:
  .byte 122
  .byte 120
  .byte 99
  .byte 118
  .byte 98
  .byte 110
  .byte 109
  .byte 44
  .byte 46
  .byte 47
  .byte 0
.section .text
  leaq .Laot_string_162(%rip), %rdi
  movq $1, %rsi
  call fr_push
  jmp .Lfranc_163
.Lfranc_161:
.section .rodata
.Laot_string_164:
  .byte 90
  .byte 88
  .byte 67
  .byte 86
  .byte 66
  .byte 78
  .byte 77
  .byte 60
  .byte 62
  .byte 63
  .byte 0
.section .text
  leaq .Laot_string_164(%rip), %rdi
  movq $1, %rsi
  call fr_push
.Lfranc_163:
  leaq reg_fw_646b2d636f6465(%rip), %rdi
  call fr_reg_get
  movabsq $44, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_add
  call fr_bfetch
  ret
.Lfranc_160:
  leaq reg_fw_646b2d636f6465(%rip), %rdi
  call fr_reg_get
  movabsq $57, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_165
  movabsq $32, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_165:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
fw_646b2d7363616e636f6465:
.comm reg_fw_646b2d7363616e,16,16
  leaq reg_fw_646b2d7363616e(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_646b2d7363616e(%rip), %rdi
  call fr_reg_get
  movabsq $224, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_166
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_646b2d657874656e646564,16,16
  leaq reg_fw_646b2d657874656e646564(%rip), %rdi
  call fr_reg_set
  movabsq $-1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_166:
  leaq reg_fw_646b2d7363616e(%rip), %rdi
  call fr_reg_get
  movabsq $42, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_167
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_646b2d7368696674,16,16
  leaq reg_fw_646b2d7368696674(%rip), %rdi
  call fr_reg_set
  movabsq $-1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_167:
  leaq reg_fw_646b2d7363616e(%rip), %rdi
  call fr_reg_get
  movabsq $54, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_168
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_646b2d7368696674,16,16
  leaq reg_fw_646b2d7368696674(%rip), %rdi
  call fr_reg_set
  movabsq $-1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_168:
  leaq reg_fw_646b2d7363616e(%rip), %rdi
  call fr_reg_get
  movabsq $170, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_169
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_646b2d7368696674,16,16
  leaq reg_fw_646b2d7368696674(%rip), %rdi
  call fr_reg_set
  movabsq $-1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_169:
  leaq reg_fw_646b2d7363616e(%rip), %rdi
  call fr_reg_get
  movabsq $182, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_170
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_646b2d7368696674,16,16
  leaq reg_fw_646b2d7368696674(%rip), %rdi
  call fr_reg_set
  movabsq $-1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_170:
  leaq reg_fw_646b2d7363616e(%rip), %rdi
  call fr_reg_get
  movabsq $128, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_band
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_171
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_646b2d657874656e646564,16,16
  leaq reg_fw_646b2d657874656e646564(%rip), %rdi
  call fr_reg_set
  movabsq $-1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_171:
  leaq reg_fw_646b2d657874656e646564(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_172
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_646b2d657874656e646564,16,16
  leaq reg_fw_646b2d657874656e646564(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_646b2d7363616e(%rip), %rdi
  call fr_reg_get
  movabsq $72, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_173
  movabsq $1001, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_173:
  leaq reg_fw_646b2d7363616e(%rip), %rdi
  call fr_reg_get
  movabsq $80, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_174
  movabsq $1002, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_174:
  leaq reg_fw_646b2d7363616e(%rip), %rdi
  call fr_reg_get
  movabsq $75, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_175
  movabsq $1003, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_175:
  leaq reg_fw_646b2d7363616e(%rip), %rdi
  call fr_reg_get
  movabsq $77, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_176
  movabsq $1004, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_176:
  movabsq $-1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_172:
  leaq reg_fw_646b2d7363616e(%rip), %rdi
  call fr_reg_get
  call fw_646b2d6d6170
.comm reg_fw_646b2d6173636969,16,16
  leaq reg_fw_646b2d6173636969(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_646b2d6173636969(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_177
  movabsq $-1, %rdi
  movabsq $1, %rsi
  call fr_push
  jmp .Lfranc_178
.Lfranc_177:
  leaq reg_fw_646b2d6173636969(%rip), %rdi
  call fr_reg_get
.Lfranc_178:
  ret
fw_646b2d7073322d706f6c6c:
  movabsq $100, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_inb
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_band
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_179
  movabsq $-1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_179:
  movabsq $96, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_inb
  call fw_646b2d7363616e636f6465
  ret
fw_646b2d706f6c6c:
  call fw_68617264776172653f
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_180
  movabsq $-1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_180:
  movabsq $1021, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_inb
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_band
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_181
  movabsq $1016, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_inb
.comm reg_fw_646b2d63686172,16,16
  leaq reg_fw_646b2d63686172(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_646b2d63686172(%rip), %rdi
  call fr_reg_get
  movabsq $13, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_182
  movabsq $10, %rdi
  movabsq $1, %rsi
  call fr_push
  jmp .Lfranc_183
.Lfranc_182:
  leaq reg_fw_646b2d63686172(%rip), %rdi
  call fr_reg_get
.Lfranc_183:
  ret
.Lfranc_181:
  call fw_646b2d7073322d706f6c6c
  ret
fw_646b2d6b6579:
  call fw_68617264776172653f
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_184
  call fw_686f73742d6b6579
  ret
.Lfranc_184:
.Lfranc_185:
  call fw_646b2d706f6c6c
.comm reg_fw_646b2d6576656e74,16,16
  leaq reg_fw_646b2d6576656e74(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_646b2d6576656e74(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_186
  leaq reg_fw_646b2d6576656e74(%rip), %rdi
  call fr_reg_get
  ret
.Lfranc_186:
  jmp .Lfranc_185
  ret
fw_6b6579:
  call fw_646b2d6b6579
  ret
fw_73322d6571:
.comm reg_fw_7332657162,16,16
  leaq reg_fw_7332657162(%rip), %rdi
  call fr_reg_set
.comm reg_fw_7332657161,16,16
  leaq reg_fw_7332657161(%rip), %rdi
  call fr_reg_set
.Lfranc_187:
  leaq reg_fw_7332657161(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
.comm reg_fw_7332657163,16,16
  leaq reg_fw_7332657163(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_7332657162(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
  leaq reg_fw_7332657163(%rip), %rdi
  call fr_reg_get
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_188
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_188:
  leaq reg_fw_7332657163(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_189
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_189:
  leaq reg_fw_7332657161(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_7332657161,16,16
  leaq reg_fw_7332657161(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_7332657162(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_7332657162,16,16
  leaq reg_fw_7332657162(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_187
  ret
fw_73322d66696e64:
.comm reg_fw_73326e6565646c65,16,16
  leaq reg_fw_73326e6565646c65(%rip), %rdi
  call fr_reg_set
  call fr_dict_head
.comm reg_fw_73326e6f6465,16,16
  leaq reg_fw_73326e6f6465(%rip), %rdi
  call fr_reg_set
.Lfranc_190:
  leaq reg_fw_73326e6f6465(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_191
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_191:
  leaq reg_fw_73326e6f6465(%rip), %rdi
  call fr_reg_get
  call fr_dict_name
  leaq reg_fw_73326e6565646c65(%rip), %rdi
  call fr_reg_get
  call fw_73322d6571
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_192
  leaq reg_fw_73326e6f6465(%rip), %rdi
  call fr_reg_get
  call fr_dict_code
  ret
.Lfranc_192:
  leaq reg_fw_73326e6f6465(%rip), %rdi
  call fr_reg_get
  call fr_dict_next
.comm reg_fw_73326e6f6465,16,16
  leaq reg_fw_73326e6f6465(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_190
  ret
fw_73322d636f7079:
  call fr_s2_token_buffer
.comm reg_fw_7332746f6b,16,16
  leaq reg_fw_7332746f6b(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_7332746f6b(%rip), %rdi
  call fr_reg_get
.comm reg_fw_73327772697465,16,16
  leaq reg_fw_73327772697465(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_733271756f7465,16,16
  leaq reg_fw_733271756f7465(%rip), %rdi
  call fr_reg_set
.Lfranc_193:
  leaq reg_fw_733270(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
.comm reg_fw_73326368,16,16
  leaq reg_fw_73326368(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_73326368(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_194
  leaq reg_fw_73327772697465(%rip), %rdi
  call fr_reg_get
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_bstore
  leaq reg_fw_7332746f6b(%rip), %rdi
  call fr_reg_get
  ret
.Lfranc_194:
  leaq reg_fw_73326368(%rip), %rdi
  call fr_reg_get
  movabsq $34, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_195
  leaq reg_fw_73327772697465(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_73326368(%rip), %rdi
  call fr_reg_get
  call fr_bstore
  leaq reg_fw_733270(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_733270,16,16
  leaq reg_fw_733270(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_73327772697465(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_73327772697465,16,16
  leaq reg_fw_73327772697465(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_733271756f7465(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_196
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_733271756f7465,16,16
  leaq reg_fw_733271756f7465(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_197
.Lfranc_196:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_733271756f7465,16,16
  leaq reg_fw_733271756f7465(%rip), %rdi
  call fr_reg_set
.Lfranc_197:
  jmp .Lfranc_198
.Lfranc_195:
  leaq reg_fw_733271756f7465(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_199
  leaq reg_fw_73326368(%rip), %rdi
  call fr_reg_get
  movabsq $33, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_200
  leaq reg_fw_73327772697465(%rip), %rdi
  call fr_reg_get
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_bstore
  leaq reg_fw_7332746f6b(%rip), %rdi
  call fr_reg_get
  ret
.Lfranc_200:
.Lfranc_199:
  leaq reg_fw_73327772697465(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_73326368(%rip), %rdi
  call fr_reg_get
  call fr_bstore
  leaq reg_fw_733270(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_733270,16,16
  leaq reg_fw_733270(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_73327772697465(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_73327772697465,16,16
  leaq reg_fw_73327772697465(%rip), %rdi
  call fr_reg_set
.Lfranc_198:
  jmp .Lfranc_193
  ret
fw_73322d6e657874:
.Lfranc_201:
  leaq reg_fw_733270(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
.comm reg_fw_73326368,16,16
  leaq reg_fw_73326368(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_73326368(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_202
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_202:
  leaq reg_fw_73326368(%rip), %rdi
  call fr_reg_get
  movabsq $33, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_203
  leaq reg_fw_733270(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_733270,16,16
  leaq reg_fw_733270(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_204
.Lfranc_203:
  call fw_73322d636f7079
  ret
.Lfranc_204:
  jmp .Lfranc_201
  ret
fw_73322d6469676974:
.comm reg_fw_733263686172,16,16
  leaq reg_fw_733263686172(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_733263686172(%rip), %rdi
  call fr_reg_get
  movabsq $48, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_205
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_205:
  leaq reg_fw_733263686172(%rip), %rdi
  call fr_reg_get
  movabsq $58, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_206
  leaq reg_fw_733263686172(%rip), %rdi
  call fr_reg_get
  movabsq $48, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_206:
  leaq reg_fw_733263686172(%rip), %rdi
  call fr_reg_get
  movabsq $65, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_207
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_207:
  leaq reg_fw_733263686172(%rip), %rdi
  call fr_reg_get
  movabsq $71, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_208
  leaq reg_fw_733263686172(%rip), %rdi
  call fr_reg_get
  movabsq $65, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  movabsq $10, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_208:
  leaq reg_fw_733263686172(%rip), %rdi
  call fr_reg_get
  movabsq $97, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_209
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_209:
  leaq reg_fw_733263686172(%rip), %rdi
  call fr_reg_get
  movabsq $103, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_210
  leaq reg_fw_733263686172(%rip), %rdi
  call fr_reg_get
  movabsq $97, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  movabsq $10, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_210:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
fw_73322d75696e74:
.comm reg_fw_73327570,16,16
  leaq reg_fw_73327570(%rip), %rdi
  call fr_reg_set
  movabsq $10, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_733262617365,16,16
  leaq reg_fw_733262617365(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_7332616363,16,16
  leaq reg_fw_7332616363(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_73327365656e,16,16
  leaq reg_fw_73327365656e(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_73327570(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
  movabsq $36, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_211
  movabsq $16, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_733262617365,16,16
  leaq reg_fw_733262617365(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_73327570(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_73327570,16,16
  leaq reg_fw_73327570(%rip), %rdi
  call fr_reg_set
.Lfranc_211:
  leaq reg_fw_73327570(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
  movabsq $35, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_212
  movabsq $2, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_733262617365,16,16
  leaq reg_fw_733262617365(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_73327570(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_73327570,16,16
  leaq reg_fw_73327570(%rip), %rdi
  call fr_reg_set
.Lfranc_212:
.Lfranc_213:
  leaq reg_fw_73327570(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
.comm reg_fw_7332756368,16,16
  leaq reg_fw_7332756368(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_7332756368(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_214
  leaq reg_fw_7332616363(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_73327570(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_73327365656e(%rip), %rdi
  call fr_reg_get
  ret
.Lfranc_214:
  leaq reg_fw_7332756368(%rip), %rdi
  call fr_reg_get
  movabsq $47, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_215
  leaq reg_fw_7332616363(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_73327570(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_73327365656e(%rip), %rdi
  call fr_reg_get
  ret
.Lfranc_215:
  leaq reg_fw_7332756368(%rip), %rdi
  call fr_reg_get
  movabsq $46, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_216
  leaq reg_fw_7332616363(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_73327570(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_73327365656e(%rip), %rdi
  call fr_reg_get
  ret
.Lfranc_216:
  leaq reg_fw_7332756368(%rip), %rdi
  call fr_reg_get
  call fw_73322d6469676974
.comm reg_fw_7332646967697476616c6964,16,16
  leaq reg_fw_7332646967697476616c6964(%rip), %rdi
  call fr_reg_set
.comm reg_fw_73326469676974,16,16
  leaq reg_fw_73326469676974(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_7332646967697476616c6964(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_217
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  leaq reg_fw_73327570(%rip), %rdi
  call fr_reg_get
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_217:
  leaq reg_fw_73326469676974(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_733262617365(%rip), %rdi
  call fr_reg_get
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_218
  leaq reg_fw_7332616363(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_733262617365(%rip), %rdi
  call fr_reg_get
  call fr_mul
  leaq reg_fw_73326469676974(%rip), %rdi
  call fr_reg_get
  call fr_add
.comm reg_fw_7332616363,16,16
  leaq reg_fw_7332616363(%rip), %rdi
  call fr_reg_set
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_73327365656e,16,16
  leaq reg_fw_73327365656e(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_73327570(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_73327570,16,16
  leaq reg_fw_73327570(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_219
.Lfranc_218:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  leaq reg_fw_73327570(%rip), %rdi
  call fr_reg_get
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_219:
  jmp .Lfranc_213
  ret
fw_73322d64656370617274:
.comm reg_fw_7332646563707472,16,16
  leaq reg_fw_7332646563707472(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_7332646563696d616c,16,16
  leaq reg_fw_7332646563696d616c(%rip), %rdi
  call fr_reg_set
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_73327363616c65,16,16
  leaq reg_fw_73327363616c65(%rip), %rdi
  call fr_reg_set
.Lfranc_220:
  leaq reg_fw_7332646563707472(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
.comm reg_fw_7332646368,16,16
  leaq reg_fw_7332646368(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_7332646368(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_221
  leaq reg_fw_7332646563696d616c(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_73327363616c65(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_221:
  leaq reg_fw_7332646368(%rip), %rdi
  call fr_reg_get
  call fw_73322d6469676974
.comm reg_fw_73326476616c6964,16,16
  leaq reg_fw_73326476616c6964(%rip), %rdi
  call fr_reg_set
.comm reg_fw_7332646967,16,16
  leaq reg_fw_7332646967(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_73326476616c6964(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_222
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_222:
  leaq reg_fw_7332646967(%rip), %rdi
  call fr_reg_get
  movabsq $10, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_223
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_223:
  leaq reg_fw_7332646967(%rip), %rdi
  call fr_reg_get
  movabsq $10, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_224
  leaq reg_fw_7332646563696d616c(%rip), %rdi
  call fr_reg_get
  movabsq $10, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_mul
  leaq reg_fw_7332646967(%rip), %rdi
  call fr_reg_get
  call fr_add
.comm reg_fw_7332646563696d616c,16,16
  leaq reg_fw_7332646563696d616c(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_73327363616c65(%rip), %rdi
  call fr_reg_get
  movabsq $10, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_mul
.comm reg_fw_73327363616c65,16,16
  leaq reg_fw_73327363616c65(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_7332646563707472(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_7332646563707472,16,16
  leaq reg_fw_7332646563707472(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_225
.Lfranc_224:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_225:
  jmp .Lfranc_220
  ret
fw_73322d6e756d626572:
.comm reg_fw_73326e70,16,16
  leaq reg_fw_73326e70(%rip), %rdi
  call fr_reg_set
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_73327369676e,16,16
  leaq reg_fw_73327369676e(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_73326e70(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
  movabsq $45, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_226
  movabsq $-1, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_73327369676e,16,16
  leaq reg_fw_73327369676e(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_73326e70(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_73326e70,16,16
  leaq reg_fw_73326e70(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_227
.Lfranc_226:
  leaq reg_fw_73326e70(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
  movabsq $43, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_228
  leaq reg_fw_73326e70(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_73326e70,16,16
  leaq reg_fw_73326e70(%rip), %rdi
  call fr_reg_set
.Lfranc_228:
.Lfranc_227:
  leaq reg_fw_73326e70(%rip), %rdi
  call fr_reg_get
  call fw_73322d75696e74
.comm reg_fw_73326e756d657261746f7276616c6964,16,16
  leaq reg_fw_73326e756d657261746f7276616c6964(%rip), %rdi
  call fr_reg_set
.comm reg_fw_7332656e64707472,16,16
  leaq reg_fw_7332656e64707472(%rip), %rdi
  call fr_reg_set
.comm reg_fw_73326e756d657261746f72,16,16
  leaq reg_fw_73326e756d657261746f72(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_73326e756d657261746f7276616c6964(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_229
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_229:
  leaq reg_fw_7332656e64707472(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_230
  leaq reg_fw_73326e756d657261746f72(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_73327369676e(%rip), %rdi
  call fr_reg_get
  call fr_mul
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_230:
  leaq reg_fw_7332656e64707472(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
  movabsq $46, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_231
  leaq reg_fw_7332656e64707472(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
  call fw_73322d64656370617274
.comm reg_fw_73326465636f6b,16,16
  leaq reg_fw_73326465636f6b(%rip), %rdi
  call fr_reg_set
.comm reg_fw_73326465637363616c65,16,16
  leaq reg_fw_73326465637363616c65(%rip), %rdi
  call fr_reg_set
.comm reg_fw_733264656366726163,16,16
  leaq reg_fw_733264656366726163(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_73326465636f6b(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_232
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_232:
  leaq reg_fw_73326e756d657261746f72(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_73326465637363616c65(%rip), %rdi
  call fr_reg_get
  call fr_mul
  leaq reg_fw_733264656366726163(%rip), %rdi
  call fr_reg_get
  call fr_add
  leaq reg_fw_73327369676e(%rip), %rdi
  call fr_reg_get
  call fr_mul
  leaq reg_fw_73326465637363616c65(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_231:
  leaq reg_fw_7332656e64707472(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
  movabsq $47, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_233
  leaq reg_fw_7332656e64707472(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
  call fw_73322d75696e74
.comm reg_fw_733264656e6f6d76616c6964,16,16
  leaq reg_fw_733264656e6f6d76616c6964(%rip), %rdi
  call fr_reg_set
.comm reg_fw_733266696e616c707472,16,16
  leaq reg_fw_733266696e616c707472(%rip), %rdi
  call fr_reg_set
.comm reg_fw_733264656e6f6d696e61746f72,16,16
  leaq reg_fw_733264656e6f6d696e61746f72(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_733264656e6f6d76616c6964(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_234
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_234:
  leaq reg_fw_733266696e616c707472(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_235
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_235:
  leaq reg_fw_73326e756d657261746f72(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_73327369676e(%rip), %rdi
  call fr_reg_get
  call fr_mul
  leaq reg_fw_733264656e6f6d696e61746f72(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_233:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
fw_73322d62797465:
.comm reg_fw_73326279746576616c7565,16,16
  leaq reg_fw_73326279746576616c7565(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_73326f7574(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_73326279746576616c7565(%rip), %rdi
  call fr_reg_get
  call fr_bstore
  leaq reg_fw_73326f7574(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_73326f7574,16,16
  leaq reg_fw_73326f7574(%rip), %rdi
  call fr_reg_set
  ret
fw_73322d753634:
.comm reg_fw_7332776f7264,16,16
  leaq reg_fw_7332776f7264(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_733269,16,16
  leaq reg_fw_733269(%rip), %rdi
  call fr_reg_set
.Lfranc_236:
  leaq reg_fw_733269(%rip), %rdi
  call fr_reg_get
  movabsq $8, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_237
  leaq reg_fw_7332776f7264(%rip), %rdi
  call fr_reg_get
  movabsq $256, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_mod
  call fw_73322d62797465
  leaq reg_fw_7332776f7264(%rip), %rdi
  call fr_reg_get
  movabsq $256, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_div
  call fr_floor
.comm reg_fw_7332776f7264,16,16
  leaq reg_fw_7332776f7264(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_733269(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_733269,16,16
  leaq reg_fw_733269(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_236
.Lfranc_237:
  ret
fw_73322d63616c6c:
.comm reg_fw_733263616c6c6565,16,16
  leaq reg_fw_733263616c6c6565(%rip), %rdi
  call fr_reg_set
  movabsq $72, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_73322d62797465
  movabsq $184, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_73322d62797465
  leaq reg_fw_733263616c6c6565(%rip), %rdi
  call fr_reg_get
  call fw_73322d753634
  movabsq $255, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_73322d62797465
  movabsq $208, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_73322d62797465
  ret
fw_73322d6c6974:
.comm reg_fw_733264656e76616c,16,16
  leaq reg_fw_733264656e76616c(%rip), %rdi
  call fr_reg_set
.comm reg_fw_73326c69746572616c,16,16
  leaq reg_fw_73326c69746572616c(%rip), %rdi
  call fr_reg_set
  movabsq $72, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_73322d62797465
  movabsq $191, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_73322d62797465
  leaq reg_fw_73326c69746572616c(%rip), %rdi
  call fr_reg_get
  call fw_73322d753634
  movabsq $72, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_73322d62797465
  movabsq $190, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_73322d62797465
  leaq reg_fw_733264656e76616c(%rip), %rdi
  call fr_reg_get
  call fw_73322d753634
  call fr_s2_lit_addr
  call fw_73322d63616c6c
  ret
fw_73322d70726f6c6f677565:
  movabsq $72, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_73322d62797465
  movabsq $131, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_73322d62797465
  movabsq $236, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_73322d62797465
  movabsq $8, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_73322d62797465
  ret
fw_73322d6570696c6f677565:
  movabsq $72, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_73322d62797465
  movabsq $131, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_73322d62797465
  movabsq $196, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_73322d62797465
  movabsq $8, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_73322d62797465
  movabsq $195, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_73322d62797465
  ret
fw_73322d753332:
.comm reg_fw_733275333276,16,16
  leaq reg_fw_733275333276(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_733275333269,16,16
  leaq reg_fw_733275333269(%rip), %rdi
  call fr_reg_set
.Lfranc_238:
  leaq reg_fw_733275333269(%rip), %rdi
  call fr_reg_get
  movabsq $4, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_239
  leaq reg_fw_733275333276(%rip), %rdi
  call fr_reg_get
  movabsq $256, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_mod
  call fw_73322d62797465
  leaq reg_fw_733275333276(%rip), %rdi
  call fr_reg_get
  movabsq $256, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_div
  call fr_floor
.comm reg_fw_733275333276,16,16
  leaq reg_fw_733275333276(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_733275333269(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_733275333269,16,16
  leaq reg_fw_733275333269(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_238
.Lfranc_239:
  ret
fw_73322d77726974653634:
.comm reg_fw_73327776,16,16
  leaq reg_fw_73327776(%rip), %rdi
  call fr_reg_set
.comm reg_fw_73327761,16,16
  leaq reg_fw_73327761(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_73327769,16,16
  leaq reg_fw_73327769(%rip), %rdi
  call fr_reg_set
.Lfranc_240:
  leaq reg_fw_73327769(%rip), %rdi
  call fr_reg_get
  movabsq $8, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_241
  leaq reg_fw_73327761(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_73327769(%rip), %rdi
  call fr_reg_get
  call fr_add
  leaq reg_fw_73327776(%rip), %rdi
  call fr_reg_get
  movabsq $256, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_mod
  call fr_bstore
  leaq reg_fw_73327776(%rip), %rdi
  call fr_reg_get
  movabsq $256, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_div
  call fr_floor
.comm reg_fw_73327776,16,16
  leaq reg_fw_73327776(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_73327769(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_73327769,16,16
  leaq reg_fw_73327769(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_240
.Lfranc_241:
  ret
fw_73322d726561643634:
.comm reg_fw_73327261,16,16
  leaq reg_fw_73327261(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_73327276,16,16
  leaq reg_fw_73327276(%rip), %rdi
  call fr_reg_set
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_73327363616c65,16,16
  leaq reg_fw_73327363616c65(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_73327269,16,16
  leaq reg_fw_73327269(%rip), %rdi
  call fr_reg_set
.Lfranc_242:
  leaq reg_fw_73327269(%rip), %rdi
  call fr_reg_get
  movabsq $8, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_243
  leaq reg_fw_73327261(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_73327269(%rip), %rdi
  call fr_reg_get
  call fr_add
  call fr_bfetch
  leaq reg_fw_73327363616c65(%rip), %rdi
  call fr_reg_get
  call fr_mul
  leaq reg_fw_73327276(%rip), %rdi
  call fr_reg_get
  call fr_add
.comm reg_fw_73327276,16,16
  leaq reg_fw_73327276(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_73327363616c65(%rip), %rdi
  call fr_reg_get
  movabsq $256, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_mul
.comm reg_fw_73327363616c65,16,16
  leaq reg_fw_73327363616c65(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_73327269(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_73327269,16,16
  leaq reg_fw_73327269(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_242
.Lfranc_243:
  leaq reg_fw_73327276(%rip), %rdi
  call fr_reg_get
  ret
fw_73322d6374726c2d70757368:
.comm reg_fw_73326374726c61646472,16,16
  leaq reg_fw_73326374726c61646472(%rip), %rdi
  call fr_reg_set
.comm reg_fw_73326374726c746167,16,16
  leaq reg_fw_73326374726c746167(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_73327370(%rip), %rdi
  call fr_reg_get
  movabsq $63, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_244
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_244:
  call fr_s2_control_buffer
  leaq reg_fw_73327370(%rip), %rdi
  call fr_reg_get
  movabsq $9, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_mul
  call fr_add
.comm reg_fw_73326672616d65,16,16
  leaq reg_fw_73326672616d65(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_73326672616d65(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_73326374726c746167(%rip), %rdi
  call fr_reg_get
  call fr_bstore
  leaq reg_fw_73326672616d65(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
  leaq reg_fw_73326374726c61646472(%rip), %rdi
  call fr_reg_get
  call fw_73322d77726974653634
  leaq reg_fw_73327370(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_73327370,16,16
  leaq reg_fw_73327370(%rip), %rdi
  call fr_reg_set
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
fw_73322d6374726c2d706f70:
  leaq reg_fw_73327370(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_245
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_245:
  leaq reg_fw_73327370(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
.comm reg_fw_73327370,16,16
  leaq reg_fw_73327370(%rip), %rdi
  call fr_reg_set
  call fr_s2_control_buffer
  leaq reg_fw_73327370(%rip), %rdi
  call fr_reg_get
  movabsq $9, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_mul
  call fr_add
.comm reg_fw_73326672616d65,16,16
  leaq reg_fw_73326672616d65(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_73326672616d65(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
  leaq reg_fw_73326672616d65(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
  call fw_73322d726561643634
  ret
fw_73322d7061746368:
.comm reg_fw_733274617267657461646472,16,16
  leaq reg_fw_733274617267657461646472(%rip), %rdi
  call fr_reg_set
.comm reg_fw_7332706174636861646472,16,16
  leaq reg_fw_7332706174636861646472(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_733274617267657461646472(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_7332706174636861646472(%rip), %rdi
  call fr_reg_get
  movabsq $4, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
  call fr_sub
  movabsq $4294967296, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_mod
.comm reg_fw_733264697370,16,16
  leaq reg_fw_733264697370(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_7332706174636869,16,16
  leaq reg_fw_7332706174636869(%rip), %rdi
  call fr_reg_set
.Lfranc_246:
  leaq reg_fw_7332706174636869(%rip), %rdi
  call fr_reg_get
  movabsq $4, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_247
  leaq reg_fw_7332706174636861646472(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_7332706174636869(%rip), %rdi
  call fr_reg_get
  call fr_add
  leaq reg_fw_733264697370(%rip), %rdi
  call fr_reg_get
  movabsq $256, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_mod
  call fr_bstore
  leaq reg_fw_733264697370(%rip), %rdi
  call fr_reg_get
  movabsq $256, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_div
  call fr_floor
.comm reg_fw_733264697370,16,16
  leaq reg_fw_733264697370(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_7332706174636869(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_7332706174636869,16,16
  leaq reg_fw_7332706174636869(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_246
.Lfranc_247:
  ret
fw_73322d6a756d70:
  movabsq $233, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_73322d62797465
  leaq reg_fw_73326f7574(%rip), %rdi
  call fr_reg_get
.comm reg_fw_73326a6d7061646472,16,16
  leaq reg_fw_73326a6d7061646472(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_73322d753332
  leaq reg_fw_73326a6d7061646472(%rip), %rdi
  call fr_reg_get
  ret
fw_73322d6272616e6368:
.comm reg_fw_73326f70636f6465,16,16
  leaq reg_fw_73326f70636f6465(%rip), %rdi
  call fr_reg_set
  call fr_s2_sign_addr
  call fw_73322d63616c6c
  movabsq $72, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_73322d62797465
  movabsq $133, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_73322d62797465
  movabsq $192, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_73322d62797465
  movabsq $15, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_73322d62797465
  leaq reg_fw_73326f70636f6465(%rip), %rdi
  call fr_reg_get
  call fw_73322d62797465
  leaq reg_fw_73326f7574(%rip), %rdi
  call fr_reg_get
.comm reg_fw_73326a6d7061646472,16,16
  leaq reg_fw_73326a6d7061646472(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_73322d753332
  leaq reg_fw_73326a6d7061646472(%rip), %rdi
  call fr_reg_get
  ret
fw_73322d636f6e74726f6c:
.comm reg_fw_733263746f6b656e,16,16
  leaq reg_fw_733263746f6b656e(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_733263746f6b656e(%rip), %rdi
  call fr_reg_get
.section .rodata
.Laot_string_248:
  .byte 105
  .byte 102
  .byte 0
.section .text
  leaq .Laot_string_248(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d6571
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_249
  movabsq $137, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_73322d6272616e6368
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_swap
  call fw_73322d6374726c2d70757368
  ret
.Lfranc_249:
  leaq reg_fw_733263746f6b656e(%rip), %rdi
  call fr_reg_get
.section .rodata
.Laot_string_250:
  .byte 105
  .byte 102
  .byte 48
  .byte 0
.section .text
  leaq .Laot_string_250(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d6571
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_251
  movabsq $133, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_73322d6272616e6368
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_swap
  call fw_73322d6374726c2d70757368
  ret
.Lfranc_251:
  leaq reg_fw_733263746f6b656e(%rip), %rdi
  call fr_reg_get
.section .rodata
.Laot_string_252:
  .byte 105
  .byte 102
  .byte 110
  .byte 122
  .byte 0
.section .text
  leaq .Laot_string_252(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d6571
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_253
  movabsq $132, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_73322d6272616e6368
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_swap
  call fw_73322d6374726c2d70757368
  ret
.Lfranc_253:
  leaq reg_fw_733263746f6b656e(%rip), %rdi
  call fr_reg_get
.section .rodata
.Laot_string_254:
  .byte 98
  .byte 101
  .byte 103
  .byte 105
  .byte 110
  .byte 0
.section .text
  leaq .Laot_string_254(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d6571
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_255
  movabsq $3, %rdi
  movabsq $1, %rsi
  call fr_push
  leaq reg_fw_73326f7574(%rip), %rdi
  call fr_reg_get
  call fw_73322d6374726c2d70757368
  ret
.Lfranc_255:
  leaq reg_fw_733263746f6b656e(%rip), %rdi
  call fr_reg_get
.section .rodata
.Laot_string_256:
  .byte 119
  .byte 104
  .byte 105
  .byte 108
  .byte 101
  .byte 0
.section .text
  leaq .Laot_string_256(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d6571
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_257
  movabsq $137, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_73322d6272616e6368
  movabsq $4, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_swap
  call fw_73322d6374726c2d70757368
  ret
.Lfranc_257:
  leaq reg_fw_733263746f6b656e(%rip), %rdi
  call fr_reg_get
.section .rodata
.Laot_string_258:
  .byte 101
  .byte 108
  .byte 115
  .byte 101
  .byte 0
.section .text
  leaq .Laot_string_258(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d6571
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_259
  call fw_73322d6374726c2d706f70
.comm reg_fw_73326f6c64706f73,16,16
  leaq reg_fw_73326f6c64706f73(%rip), %rdi
  call fr_reg_set
.comm reg_fw_73326f6c64746167,16,16
  leaq reg_fw_73326f6c64746167(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_73326f6c64746167(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_260
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_260:
  call fw_73322d6a756d70
.comm reg_fw_7332656c7365706f73,16,16
  leaq reg_fw_7332656c7365706f73(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_73326f6c64706f73(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_73326f7574(%rip), %rdi
  call fr_reg_get
  call fw_73322d7061746368
  movabsq $2, %rdi
  movabsq $1, %rsi
  call fr_push
  leaq reg_fw_7332656c7365706f73(%rip), %rdi
  call fr_reg_get
  call fw_73322d6374726c2d70757368
  ret
.Lfranc_259:
  leaq reg_fw_733263746f6b656e(%rip), %rdi
  call fr_reg_get
.section .rodata
.Laot_string_261:
  .byte 116
  .byte 104
  .byte 101
  .byte 110
  .byte 0
.section .text
  leaq .Laot_string_261(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d6571
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_262
  call fw_73322d6374726c2d706f70
.comm reg_fw_73326f6c64706f73,16,16
  leaq reg_fw_73326f6c64706f73(%rip), %rdi
  call fr_reg_set
.comm reg_fw_73326f6c64746167,16,16
  leaq reg_fw_73326f6c64746167(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_73326f6c64746167(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_263
  leaq reg_fw_73326f6c64706f73(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_73326f7574(%rip), %rdi
  call fr_reg_get
  call fw_73322d7061746368
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_263:
  leaq reg_fw_73326f6c64746167(%rip), %rdi
  call fr_reg_get
  movabsq $2, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_264
  leaq reg_fw_73326f6c64706f73(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_73326f7574(%rip), %rdi
  call fr_reg_get
  call fw_73322d7061746368
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_264:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_262:
  leaq reg_fw_733263746f6b656e(%rip), %rdi
  call fr_reg_get
.section .rodata
.Laot_string_265:
  .byte 97
  .byte 103
  .byte 97
  .byte 105
  .byte 110
  .byte 0
.section .text
  leaq .Laot_string_265(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d6571
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_266
  call fw_73322d6374726c2d706f70
.comm reg_fw_73326f6c64706f73,16,16
  leaq reg_fw_73326f6c64706f73(%rip), %rdi
  call fr_reg_set
.comm reg_fw_73326f6c64746167,16,16
  leaq reg_fw_73326f6c64746167(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_73326f6c64746167(%rip), %rdi
  call fr_reg_get
  movabsq $3, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_267
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_267:
  call fw_73322d6a756d70
  leaq reg_fw_73326f6c64706f73(%rip), %rdi
  call fr_reg_get
  call fw_73322d7061746368
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_266:
  leaq reg_fw_733263746f6b656e(%rip), %rdi
  call fr_reg_get
.section .rodata
.Laot_string_268:
  .byte 114
  .byte 101
  .byte 112
  .byte 101
  .byte 97
  .byte 116
  .byte 0
.section .text
  leaq .Laot_string_268(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d6571
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_269
  call fw_73322d6374726c2d706f70
.comm reg_fw_73326f6c64706f73,16,16
  leaq reg_fw_73326f6c64706f73(%rip), %rdi
  call fr_reg_set
.comm reg_fw_73326f6c64746167,16,16
  leaq reg_fw_73326f6c64746167(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_73326f6c64746167(%rip), %rdi
  call fr_reg_get
  movabsq $4, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_270
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_270:
  leaq reg_fw_73326f6c64706f73(%rip), %rdi
  call fr_reg_get
.comm reg_fw_73327768696c65706f73,16,16
  leaq reg_fw_73327768696c65706f73(%rip), %rdi
  call fr_reg_set
  call fw_73322d6374726c2d706f70
.comm reg_fw_73326f6c64706f73,16,16
  leaq reg_fw_73326f6c64706f73(%rip), %rdi
  call fr_reg_set
.comm reg_fw_73326f6c64746167,16,16
  leaq reg_fw_73326f6c64746167(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_73326f6c64746167(%rip), %rdi
  call fr_reg_get
  movabsq $3, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_271
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_271:
  call fw_73322d6a756d70
  leaq reg_fw_73326f6c64706f73(%rip), %rdi
  call fr_reg_get
  call fw_73322d7061746368
  leaq reg_fw_73327768696c65706f73(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_73326f7574(%rip), %rdi
  call fr_reg_get
  call fw_73322d7061746368
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_269:
  leaq reg_fw_733263746f6b656e(%rip), %rdi
  call fr_reg_get
.section .rodata
.Laot_string_272:
  .byte 101
  .byte 120
  .byte 105
  .byte 116
  .byte 0
.section .text
  leaq .Laot_string_272(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d6571
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_273
  call fw_73322d6570696c6f677565
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_273:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
fw_73322d737472696e672d6c6974:
.comm reg_fw_7332737472,16,16
  leaq reg_fw_7332737472(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_7332737472(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_7332696e6e6572,16,16
  leaq reg_fw_7332696e6e6572(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_7332696e6e6572(%rip), %rdi
  call fr_reg_get
.comm reg_fw_73327363616e,16,16
  leaq reg_fw_73327363616e(%rip), %rdi
  call fr_reg_set
.Lfranc_274:
  leaq reg_fw_73327363616e(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_275
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_275:
  leaq reg_fw_73327363616e(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
  movabsq $34, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_276
  leaq reg_fw_73327363616e(%rip), %rdi
  call fr_reg_get
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_bstore
  leaq reg_fw_7332696e6e6572(%rip), %rdi
  call fr_reg_get
  call fr_s2_intern
.comm reg_fw_73326f776e6564,16,16
  leaq reg_fw_73326f776e6564(%rip), %rdi
  call fr_reg_set
  movabsq $72, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_73322d62797465
  movabsq $191, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_73322d62797465
  leaq reg_fw_73326f776e6564(%rip), %rdi
  call fr_reg_get
  call fw_73322d753634
  call fr_s2_string_addr
  call fw_73322d63616c6c
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_276:
  leaq reg_fw_73327363616e(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_73327363616e,16,16
  leaq reg_fw_73327363616e(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_274
  ret
fw_73322d746f6b656e2d656d6974:
.comm reg_fw_7332746f6b656e,16,16
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
  movabsq $34, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_277
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_get
  call fw_73322d737472696e672d6c6974
  ret
.Lfranc_277:
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_get
  call fw_73322d66696e64
.comm reg_fw_7332746172676574,16,16
  leaq reg_fw_7332746172676574(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_7332746172676574(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_278
  leaq reg_fw_7332746172676574(%rip), %rdi
  call fr_reg_get
  call fw_73322d63616c6c
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_278:
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
  movabsq $39, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_279
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
  call fw_73322d66696e64
.comm reg_fw_733271756f746561646472,16,16
  leaq reg_fw_733271756f746561646472(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_733271756f746561646472(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_280
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_280:
  leaq reg_fw_733271756f746561646472(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_73322d6c6974
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_279:
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_get
.section .rodata
.Laot_string_281:
  .byte 105
  .byte 102
  .byte 0
.section .text
  leaq .Laot_string_281(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d6571
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_282
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_get
  call fw_73322d636f6e74726f6c
  ret
.Lfranc_282:
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_get
.section .rodata
.Laot_string_283:
  .byte 105
  .byte 102
  .byte 48
  .byte 0
.section .text
  leaq .Laot_string_283(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d6571
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_284
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_get
  call fw_73322d636f6e74726f6c
  ret
.Lfranc_284:
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_get
.section .rodata
.Laot_string_285:
  .byte 105
  .byte 102
  .byte 110
  .byte 122
  .byte 0
.section .text
  leaq .Laot_string_285(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d6571
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_286
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_get
  call fw_73322d636f6e74726f6c
  ret
.Lfranc_286:
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_get
.section .rodata
.Laot_string_287:
  .byte 101
  .byte 108
  .byte 115
  .byte 101
  .byte 0
.section .text
  leaq .Laot_string_287(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d6571
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_288
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_get
  call fw_73322d636f6e74726f6c
  ret
.Lfranc_288:
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_get
.section .rodata
.Laot_string_289:
  .byte 116
  .byte 104
  .byte 101
  .byte 110
  .byte 0
.section .text
  leaq .Laot_string_289(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d6571
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_290
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_get
  call fw_73322d636f6e74726f6c
  ret
.Lfranc_290:
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_get
.section .rodata
.Laot_string_291:
  .byte 98
  .byte 101
  .byte 103
  .byte 105
  .byte 110
  .byte 0
.section .text
  leaq .Laot_string_291(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d6571
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_292
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_get
  call fw_73322d636f6e74726f6c
  ret
.Lfranc_292:
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_get
.section .rodata
.Laot_string_293:
  .byte 119
  .byte 104
  .byte 105
  .byte 108
  .byte 101
  .byte 0
.section .text
  leaq .Laot_string_293(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d6571
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_294
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_get
  call fw_73322d636f6e74726f6c
  ret
.Lfranc_294:
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_get
.section .rodata
.Laot_string_295:
  .byte 114
  .byte 101
  .byte 112
  .byte 101
  .byte 97
  .byte 116
  .byte 0
.section .text
  leaq .Laot_string_295(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d6571
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_296
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_get
  call fw_73322d636f6e74726f6c
  ret
.Lfranc_296:
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_get
.section .rodata
.Laot_string_297:
  .byte 97
  .byte 103
  .byte 97
  .byte 105
  .byte 110
  .byte 0
.section .text
  leaq .Laot_string_297(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d6571
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_298
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_get
  call fw_73322d636f6e74726f6c
  ret
.Lfranc_298:
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_get
.section .rodata
.Laot_string_299:
  .byte 101
  .byte 120
  .byte 105
  .byte 116
  .byte 0
.section .text
  leaq .Laot_string_299(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d6571
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_300
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_get
  call fw_73322d636f6e74726f6c
  ret
.Lfranc_300:
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_get
  call fw_73322d66696e64
.comm reg_fw_7332746172676574,16,16
  leaq reg_fw_7332746172676574(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_7332746172676574(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_301
  leaq reg_fw_7332746172676574(%rip), %rdi
  call fr_reg_get
  call fw_73322d63616c6c
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_301:
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_get
  call fw_73322d6e756d626572
.comm reg_fw_733276616c6964,16,16
  leaq reg_fw_733276616c6964(%rip), %rdi
  call fr_reg_set
.comm reg_fw_733264656e76616c32,16,16
  leaq reg_fw_733264656e76616c32(%rip), %rdi
  call fr_reg_set
.comm reg_fw_73326c697476616c,16,16
  leaq reg_fw_73326c697476616c(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_733276616c6964(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_302
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_302:
  leaq reg_fw_73326c697476616c(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_733264656e76616c32(%rip), %rdi
  call fr_reg_get
  call fw_73322d6c6974
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
fw_73322d636f6d70696c65:
.comm reg_fw_733270,16,16
  leaq reg_fw_733270(%rip), %rdi
  call fr_reg_set
  call fw_73322d6e657874
.comm reg_fw_7332746f6b656e,16,16
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_303
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_303:
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_get
.section .rodata
.Laot_string_304:
  .byte 100
  .byte 101
  .byte 102
  .byte 0
.section .text
  leaq .Laot_string_304(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d6571
.comm reg_fw_73326465666d6f6465,16,16
  leaq reg_fw_73326465666d6f6465(%rip), %rdi
  call fr_reg_set
  call fr_s2_code
.comm reg_fw_7332626567696e,16,16
  leaq reg_fw_7332626567696e(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_7332626567696e(%rip), %rdi
  call fr_reg_get
.comm reg_fw_73326f7574,16,16
  leaq reg_fw_73326f7574(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_73327370,16,16
  leaq reg_fw_73327370(%rip), %rdi
  call fr_reg_set
  call fw_73322d70726f6c6f677565
  leaq reg_fw_73326465666d6f6465(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_305
  call fw_73322d6e657874
.comm reg_fw_7332746f6b656e,16,16
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_306
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_306:
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_7332626567696e(%rip), %rdi
  call fr_reg_get
  call fr_s2_define
  jmp .Lfranc_307
.Lfranc_305:
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_get
  call fw_73322d746f6b656e2d656d6974
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_308
.section .rodata
.Laot_string_309:
  .byte 115
  .byte 116
  .byte 97
  .byte 103
  .byte 101
  .byte 50
  .byte 58
  .byte 32
  .byte 117
  .byte 110
  .byte 115
  .byte 117
  .byte 112
  .byte 112
  .byte 111
  .byte 114
  .byte 116
  .byte 101
  .byte 100
  .byte 32
  .byte 116
  .byte 111
  .byte 107
  .byte 101
  .byte 110
  .byte 0
.section .text
  leaq .Laot_string_309(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_308:
.Lfranc_307:
.Lfranc_310:
  call fw_73322d6e657874
.comm reg_fw_7332746f6b656e,16,16
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_311
  leaq reg_fw_73327370(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_312
.section .rodata
.Laot_string_313:
  .byte 115
  .byte 116
  .byte 97
  .byte 103
  .byte 101
  .byte 50
  .byte 58
  .byte 32
  .byte 117
  .byte 110
  .byte 99
  .byte 108
  .byte 111
  .byte 115
  .byte 101
  .byte 100
  .byte 32
  .byte 99
  .byte 111
  .byte 110
  .byte 116
  .byte 114
  .byte 111
  .byte 108
  .byte 0
.section .text
  leaq .Laot_string_313(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_312:
  call fw_73322d6570696c6f677565
  leaq reg_fw_7332626567696e(%rip), %rdi
  call fr_reg_get
  ret
.Lfranc_311:
  leaq reg_fw_73326465666d6f6465(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_314
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_get
.section .rodata
.Laot_string_315:
  .byte 59
  .byte 0
.section .text
  leaq .Laot_string_315(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d6571
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_316
  leaq reg_fw_73327370(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_317
.section .rodata
.Laot_string_318:
  .byte 115
  .byte 116
  .byte 97
  .byte 103
  .byte 101
  .byte 50
  .byte 58
  .byte 32
  .byte 117
  .byte 110
  .byte 99
  .byte 108
  .byte 111
  .byte 115
  .byte 101
  .byte 100
  .byte 32
  .byte 99
  .byte 111
  .byte 110
  .byte 116
  .byte 114
  .byte 111
  .byte 108
  .byte 0
.section .text
  leaq .Laot_string_318(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_317:
  call fw_73322d6570696c6f677565
  leaq reg_fw_7332626567696e(%rip), %rdi
  call fr_reg_get
  ret
.Lfranc_316:
.Lfranc_314:
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  call fr_reg_get
  call fw_73322d746f6b656e2d656d6974
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_319
.section .rodata
.Laot_string_320:
  .byte 115
  .byte 116
  .byte 97
  .byte 103
  .byte 101
  .byte 50
  .byte 58
  .byte 32
  .byte 117
  .byte 110
  .byte 115
  .byte 117
  .byte 112
  .byte 112
  .byte 111
  .byte 114
  .byte 116
  .byte 101
  .byte 100
  .byte 32
  .byte 116
  .byte 111
  .byte 107
  .byte 101
  .byte 110
  .byte 0
.section .text
  leaq .Laot_string_320(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_319:
  jmp .Lfranc_310
  ret
fw_73322d726561642d6c696e65:
  call fr_s2_line_buffer
.comm reg_fw_7332647374,16,16
  leaq reg_fw_7332647374(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_73326c696e652d6c656e,16,16
  leaq reg_fw_73326c696e652d6c656e(%rip), %rdi
  call fr_reg_set
.Lfranc_321:
  leaq reg_fw_733273726369(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
.comm reg_fw_73327363686172,16,16
  leaq reg_fw_73327363686172(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_73327363686172(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_322
  leaq reg_fw_7332647374(%rip), %rdi
  call fr_reg_get
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_bstore
  leaq reg_fw_73326c696e652d6c656e(%rip), %rdi
  call fr_reg_get
  ret
.Lfranc_322:
  leaq reg_fw_73327363686172(%rip), %rdi
  call fr_reg_get
  movabsq $10, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_323
  leaq reg_fw_733273726369(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_733273726369,16,16
  leaq reg_fw_733273726369(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_7332647374(%rip), %rdi
  call fr_reg_get
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_bstore
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_323:
  leaq reg_fw_7332647374(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_73327363686172(%rip), %rdi
  call fr_reg_get
  call fr_bstore
  leaq reg_fw_7332647374(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_7332647374,16,16
  leaq reg_fw_7332647374(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_733273726369(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_733273726369,16,16
  leaq reg_fw_733273726369(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_73326c696e652d6c656e(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_73326c696e652d6c656e,16,16
  leaq reg_fw_73326c696e652d6c656e(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_321
  ret
fw_73322d736f75726365:
.comm reg_fw_733273726369,16,16
  leaq reg_fw_733273726369(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_73326c696e6573,16,16
  leaq reg_fw_73326c696e6573(%rip), %rdi
  call fr_reg_set
.Lfranc_324:
  call fw_73322d726561642d6c696e65
.comm reg_fw_7332657869737473,16,16
  leaq reg_fw_7332657869737473(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_7332657869737473(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_325
  leaq reg_fw_73326c696e6573(%rip), %rdi
  call fr_reg_get
  ret
.Lfranc_325:
  call fr_s2_line_buffer
  call fr_bfetch
.comm reg_fw_73326669727374,16,16
  leaq reg_fw_73326669727374(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_73326669727374(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_326
  leaq reg_fw_73326669727374(%rip), %rdi
  call fr_reg_get
  movabsq $92, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_327
  call fr_s2_line_buffer
  call fw_73322d636f6d70696c65
  call fr_drop
  leaq reg_fw_73326c696e6573(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_73326c696e6573,16,16
  leaq reg_fw_73326c696e6573(%rip), %rdi
  call fr_reg_set
.Lfranc_327:
.Lfranc_326:
  jmp .Lfranc_324
  ret
fw_73322d6576616c:
.comm reg_fw_73326576616c2d74657874,16,16
  leaq reg_fw_73326576616c2d74657874(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_73326576616c2d74657874(%rip), %rdi
  call fr_reg_get
.comm reg_fw_733270,16,16
  leaq reg_fw_733270(%rip), %rdi
  call fr_reg_set
  call fw_73322d6e657874
.section .rodata
.Laot_string_328:
  .byte 100
  .byte 101
  .byte 102
  .byte 0
.section .text
  leaq .Laot_string_328(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d6571
.comm reg_fw_73326576616c2d646566,16,16
  leaq reg_fw_73326576616c2d646566(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_73326576616c2d74657874(%rip), %rdi
  call fr_reg_get
  call fw_73322d636f6d70696c65
.comm reg_fw_73326576616c2d636f6465,16,16
  leaq reg_fw_73326576616c2d636f6465(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_73326576616c2d636f6465(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_329
  ret
.Lfranc_329:
  leaq reg_fw_73326576616c2d646566(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_330
  leaq reg_fw_73326576616c2d636f6465(%rip), %rdi
  call fr_reg_get
  call fr_s2_run
.Lfranc_330:
  ret
fw_726c2d6572617365:
  leaq reg_fw_726c2d6c656e(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_331
  leaq reg_fw_726c2d6c656e(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
.comm reg_fw_726c2d6c656e,16,16
  leaq reg_fw_726c2d6c656e(%rip), %rdi
  call fr_reg_set
  call fr_repl_buffer
  leaq reg_fw_726c2d6c656e(%rip), %rdi
  call fr_reg_get
  call fr_add
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_bstore
  movabsq $8, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_76632d707574
  movabsq $32, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_76632d707574
  movabsq $8, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_76632d707574
.Lfranc_331:
  ret
fw_726c2d617070656e64:
  leaq reg_fw_726c2d6c656e(%rip), %rdi
  call fr_reg_get
  movabsq $255, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_332
  call fr_repl_buffer
  leaq reg_fw_726c2d6c656e(%rip), %rdi
  call fr_reg_get
  call fr_add
  leaq reg_fw_726c2d6368(%rip), %rdi
  call fr_reg_get
  call fr_bstore
  leaq reg_fw_726c2d6368(%rip), %rdi
  call fr_reg_get
  call fw_76632d707574
  leaq reg_fw_726c2d6c656e(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_726c2d6c656e,16,16
  leaq reg_fw_726c2d6c656e(%rip), %rdi
  call fr_reg_set
  call fr_repl_buffer
  leaq reg_fw_726c2d6c656e(%rip), %rdi
  call fr_reg_get
  call fr_add
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_bstore
.Lfranc_332:
  ret
fw_726c2d72656164:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_726c2d6c656e,16,16
  leaq reg_fw_726c2d6c656e(%rip), %rdi
  call fr_reg_set
  call fr_repl_buffer
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_bstore
.Lfranc_333:
  call fw_646b2d6b6579
.comm reg_fw_726c2d6368,16,16
  leaq reg_fw_726c2d6368(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_726c2d6368(%rip), %rdi
  call fr_reg_get
  movabsq $27, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_334
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_334:
  leaq reg_fw_726c2d6368(%rip), %rdi
  call fr_reg_get
  movabsq $10, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_335
  movabsq $10, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_76632d707574
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_335:
  leaq reg_fw_726c2d6368(%rip), %rdi
  call fr_reg_get
  movabsq $13, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_336
  movabsq $10, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_76632d707574
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_336:
  leaq reg_fw_726c2d6368(%rip), %rdi
  call fr_reg_get
  movabsq $8, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_337
  call fw_726c2d6572617365
  jmp .Lfranc_338
.Lfranc_337:
  leaq reg_fw_726c2d6368(%rip), %rdi
  call fr_reg_get
  movabsq $127, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_339
  call fw_726c2d6572617365
  jmp .Lfranc_340
.Lfranc_339:
  leaq reg_fw_726c2d6368(%rip), %rdi
  call fr_reg_get
  movabsq $32, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_341
  jmp .Lfranc_342
.Lfranc_341:
  leaq reg_fw_726c2d6368(%rip), %rdi
  call fr_reg_get
  movabsq $127, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_343
  call fw_726c2d617070656e64
.Lfranc_343:
.Lfranc_342:
.Lfranc_340:
.Lfranc_338:
  jmp .Lfranc_333
  ret
fw_726c2d6576616c:
  call fr_depth
.comm reg_fw_726c2d6265666f7265,16,16
  leaq reg_fw_726c2d6265666f7265(%rip), %rdi
  call fr_reg_set
  call fr_repl_buffer
  call fw_73322d6576616c
  call fr_depth
  leaq reg_fw_726c2d6265666f7265(%rip), %rdi
  call fr_reg_get
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_344
  call fr_dot
.Lfranc_344:
  ret
fw_726c2d6d61696e:
.section .rodata
.Laot_string_345:
  .byte 70
  .byte 114
  .byte 97
  .byte 110
  .byte 99
  .byte 32
  .byte 82
  .byte 69
  .byte 80
  .byte 76
  .byte 32
  .byte 124
  .byte 32
  .byte 69
  .byte 115
  .byte 99
  .byte 32
  .byte 114
  .byte 101
  .byte 116
  .byte 117
  .byte 114
  .byte 110
  .byte 115
  .byte 32
  .byte 116
  .byte 111
  .byte 32
  .byte 109
  .byte 101
  .byte 110
  .byte 117
  .byte 0
.section .text
  leaq .Laot_string_345(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_76632d74797065
  call fw_76632d6e65776c696e65
.Lfranc_346:
.section .rodata
.Laot_string_347:
  .byte 70
  .byte 114
  .byte 97
  .byte 99
  .byte 62
  .byte 32
  .byte 0
.section .text
  leaq .Laot_string_347(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_76632d74797065
  call fw_726c2d72656164
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_348
  ret
.Lfranc_348:
  call fr_repl_buffer
  call fr_bfetch
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_349
  call fw_726c2d6576616c
.Lfranc_349:
  jmp .Lfranc_346
  ret
fw_757067726164652d6c6f6164:
.section .rodata
.Laot_string_350:
  .byte 115
  .byte 116
  .byte 97
  .byte 114
  .byte 116
  .byte 117
  .byte 112
  .byte 46
  .byte 102
  .byte 114
  .byte 97
  .byte 99
  .byte 0
.section .text
  leaq .Laot_string_350(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_66732d736f75726365
.comm reg_fw_75672d736f75726365,16,16
  leaq reg_fw_75672d736f75726365(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_75672d736f75726365(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_351
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_351:
.section .rodata
.Laot_string_352:
  .byte 115
  .byte 116
  .byte 97
  .byte 114
  .byte 116
  .byte 117
  .byte 112
  .byte 45
  .byte 109
  .byte 97
  .byte 105
  .byte 110
  .byte 0
.section .text
  leaq .Laot_string_352(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d66696e64
.comm reg_fw_75672d6265666f7265,16,16
  leaq reg_fw_75672d6265666f7265(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_75672d736f75726365(%rip), %rdi
  call fr_reg_get
  call fw_73322d736f75726365
  call fr_drop
.section .rodata
.Laot_string_353:
  .byte 115
  .byte 116
  .byte 97
  .byte 114
  .byte 116
  .byte 117
  .byte 112
  .byte 45
  .byte 109
  .byte 97
  .byte 105
  .byte 110
  .byte 0
.section .text
  leaq .Laot_string_353(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d66696e64
.comm reg_fw_75672d6166746572,16,16
  leaq reg_fw_75672d6166746572(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_75672d6166746572(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_354
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_354:
  leaq reg_fw_75672d6166746572(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_75672d6265666f7265(%rip), %rdi
  call fr_reg_get
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_355
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_355:
  leaq reg_fw_75672d6166746572(%rip), %rdi
  call fr_reg_get
  call fr_s2_run
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
fw_616f742d646563:
.comm reg_fw_61642d6e,16,16
  leaq reg_fw_61642d6e(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_61642d7374617274,16,16
  leaq reg_fw_61642d7374617274(%rip), %rdi
  call fr_reg_set
  movabsq $1000000000000000000, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_61642d706c616365,16,16
  leaq reg_fw_61642d706c616365(%rip), %rdi
  call fr_reg_set
.Lfranc_356:
  leaq reg_fw_61642d706c616365(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_357
  leaq reg_fw_61642d7374617274(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_358
  movabsq $48, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_emit
.Lfranc_358:
  ret
.Lfranc_357:
  leaq reg_fw_61642d6e(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_61642d706c616365(%rip), %rdi
  call fr_reg_get
  call fr_div
  call fr_floor
  movabsq $10, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_mod
.comm reg_fw_61642d6469676974,16,16
  leaq reg_fw_61642d6469676974(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_61642d6469676974(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_359
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_61642d7374617274,16,16
  leaq reg_fw_61642d7374617274(%rip), %rdi
  call fr_reg_set
.Lfranc_359:
  leaq reg_fw_61642d7374617274(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_360
  leaq reg_fw_61642d6469676974(%rip), %rdi
  call fr_reg_get
  movabsq $48, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
  call fr_emit
.Lfranc_360:
  leaq reg_fw_61642d706c616365(%rip), %rdi
  call fr_reg_get
  movabsq $10, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_div
  call fr_floor
.comm reg_fw_61642d706c616365,16,16
  leaq reg_fw_61642d706c616365(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_356
  ret
fw_616f742d7369676e6564:
.comm reg_fw_61732d6e,16,16
  leaq reg_fw_61732d6e(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_61732d6e(%rip), %rdi
  call fr_reg_get
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_361
  movabsq $45, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_emit
  leaq reg_fw_61732d6e(%rip), %rdi
  call fr_reg_get
  call fr_neg
  call fw_616f742d646563
  jmp .Lfranc_362
.Lfranc_361:
  leaq reg_fw_61732d6e(%rip), %rdi
  call fr_reg_get
  call fw_616f742d646563
.Lfranc_362:
  ret
fw_616f742d666974733332:
.comm reg_fw_61662d76,16,16
  leaq reg_fw_61662d76(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_61662d76(%rip), %rdi
  call fr_reg_get
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_363
  leaq reg_fw_61662d76(%rip), %rdi
  call fr_reg_get
  call fr_neg
.comm reg_fw_61662d76,16,16
  leaq reg_fw_61662d76(%rip), %rdi
  call fr_reg_set
.Lfranc_363:
  leaq reg_fw_61662d76(%rip), %rdi
  call fr_reg_get
  movabsq $2147483648, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_364
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  jmp .Lfranc_365
.Lfranc_364:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.Lfranc_365:
  ret
fw_616f742d6c69746572616c:
.comm reg_fw_616c2d64656e,16,16
  leaq reg_fw_616c2d64656e(%rip), %rdi
  call fr_reg_set
.comm reg_fw_616c2d6e756d,16,16
  leaq reg_fw_616c2d6e756d(%rip), %rdi
  call fr_reg_set
.section .rodata
.Laot_string_366:
  .byte 32
  .byte 32
  .byte 109
  .byte 111
  .byte 118
  .byte 97
  .byte 98
  .byte 115
  .byte 113
  .byte 32
  .byte 36
  .byte 0
.section .text
  leaq .Laot_string_366(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  leaq reg_fw_616c2d6e756d(%rip), %rdi
  call fr_reg_get
  call fw_616f742d7369676e6564
.section .rodata
.Laot_string_367:
  .byte 44
  .byte 32
  .byte 37
  .byte 114
  .byte 100
  .byte 105
  .byte 0
.section .text
  leaq .Laot_string_367(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  movabsq $10, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_emit
.section .rodata
.Laot_string_368:
  .byte 32
  .byte 32
  .byte 109
  .byte 111
  .byte 118
  .byte 97
  .byte 98
  .byte 115
  .byte 113
  .byte 32
  .byte 36
  .byte 0
.section .text
  leaq .Laot_string_368(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  leaq reg_fw_616c2d64656e(%rip), %rdi
  call fr_reg_get
  call fw_616f742d7369676e6564
.section .rodata
.Laot_string_369:
  .byte 44
  .byte 32
  .byte 37
  .byte 114
  .byte 115
  .byte 105
  .byte 0
.section .text
  leaq .Laot_string_369(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  movabsq $10, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_emit
.section .rodata
.Laot_string_370:
  .byte 32
  .byte 32
  .byte 99
  .byte 97
  .byte 108
  .byte 108
  .byte 32
  .byte 102
  .byte 114
  .byte 95
  .byte 112
  .byte 117
  .byte 115
  .byte 104
  .byte 0
.section .text
  leaq .Laot_string_370(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  movabsq $10, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_emit
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
fw_616f742d6f70732d6f6e65:
.section .rodata
.Laot_string_371:
  .byte 43
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 97
  .byte 100
  .byte 100
  .byte 124
  .byte 45
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 115
  .byte 117
  .byte 98
  .byte 124
  .byte 42
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 109
  .byte 117
  .byte 108
  .byte 124
  .byte 47
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 100
  .byte 105
  .byte 118
  .byte 124
  .byte 100
  .byte 117
  .byte 112
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 100
  .byte 117
  .byte 112
  .byte 124
  .byte 100
  .byte 114
  .byte 111
  .byte 112
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 100
  .byte 114
  .byte 111
  .byte 112
  .byte 124
  .byte 115
  .byte 119
  .byte 97
  .byte 112
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 115
  .byte 119
  .byte 97
  .byte 112
  .byte 124
  .byte 111
  .byte 118
  .byte 101
  .byte 114
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 111
  .byte 118
  .byte 101
  .byte 114
  .byte 124
  .byte 46
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 100
  .byte 111
  .byte 116
  .byte 124
  .byte 101
  .byte 109
  .byte 105
  .byte 116
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 101
  .byte 109
  .byte 105
  .byte 116
  .byte 124
  .byte 116
  .byte 121
  .byte 112
  .byte 101
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 116
  .byte 121
  .byte 112
  .byte 101
  .byte 124
  .byte 99
  .byte 114
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 99
  .byte 114
  .byte 124
  .byte 112
  .byte 105
  .byte 120
  .byte 101
  .byte 108
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 112
  .byte 105
  .byte 120
  .byte 101
  .byte 108
  .byte 124
  .byte 99
  .byte 108
  .byte 101
  .byte 97
  .byte 114
  .byte 102
  .byte 98
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 99
  .byte 108
  .byte 101
  .byte 97
  .byte 114
  .byte 124
  .byte 107
  .byte 101
  .byte 121
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 107
  .byte 101
  .byte 121
  .byte 124
  .byte 107
  .byte 101
  .byte 121
  .byte 63
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 107
  .byte 101
  .byte 121
  .byte 113
  .byte 124
  .byte 100
  .byte 101
  .byte 112
  .byte 116
  .byte 104
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 100
  .byte 101
  .byte 112
  .byte 116
  .byte 104
  .byte 124
  .byte 110
  .byte 101
  .byte 103
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 110
  .byte 101
  .byte 103
  .byte 124
  .byte 97
  .byte 98
  .byte 115
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 97
  .byte 98
  .byte 115
  .byte 124
  .byte 102
  .byte 108
  .byte 111
  .byte 111
  .byte 114
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 102
  .byte 108
  .byte 111
  .byte 111
  .byte 114
  .byte 124
  .byte 98
  .byte 64
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 98
  .byte 102
  .byte 101
  .byte 116
  .byte 99
  .byte 104
  .byte 124
  .byte 98
  .byte 33
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 98
  .byte 115
  .byte 116
  .byte 111
  .byte 114
  .byte 101
  .byte 124
  .byte 105
  .byte 111
  .byte 56
  .byte 64
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 105
  .byte 110
  .byte 98
  .byte 124
  .byte 105
  .byte 111
  .byte 56
  .byte 33
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 111
  .byte 117
  .byte 116
  .byte 98
  .byte 124
  .byte 105
  .byte 111
  .byte 49
  .byte 54
  .byte 64
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 105
  .byte 110
  .byte 119
  .byte 124
  .byte 105
  .byte 111
  .byte 49
  .byte 54
  .byte 33
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 111
  .byte 117
  .byte 116
  .byte 119
  .byte 124
  .byte 105
  .byte 111
  .byte 51
  .byte 50
  .byte 64
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 105
  .byte 110
  .byte 108
  .byte 124
  .byte 105
  .byte 111
  .byte 51
  .byte 50
  .byte 33
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 111
  .byte 117
  .byte 116
  .byte 108
  .byte 124
  .byte 109
  .byte 109
  .byte 105
  .byte 111
  .byte 51
  .byte 50
  .byte 64
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 109
  .byte 109
  .byte 105
  .byte 111
  .byte 51
  .byte 50
  .byte 95
  .byte 102
  .byte 101
  .byte 116
  .byte 99
  .byte 104
  .byte 124
  .byte 109
  .byte 109
  .byte 105
  .byte 111
  .byte 51
  .byte 50
  .byte 33
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 109
  .byte 109
  .byte 105
  .byte 111
  .byte 51
  .byte 50
  .byte 95
  .byte 115
  .byte 116
  .byte 111
  .byte 114
  .byte 101
  .byte 124
  .byte 98
  .byte 97
  .byte 110
  .byte 100
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 98
  .byte 97
  .byte 110
  .byte 100
  .byte 124
  .byte 115
  .byte 101
  .byte 99
  .byte 116
  .byte 111
  .byte 114
  .byte 45
  .byte 98
  .byte 121
  .byte 116
  .byte 101
  .byte 64
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 115
  .byte 101
  .byte 99
  .byte 116
  .byte 111
  .byte 114
  .byte 95
  .byte 98
  .byte 102
  .byte 101
  .byte 116
  .byte 99
  .byte 104
  .byte 124
  .byte 115
  .byte 101
  .byte 99
  .byte 116
  .byte 111
  .byte 114
  .byte 45
  .byte 98
  .byte 121
  .byte 116
  .byte 101
  .byte 33
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 115
  .byte 101
  .byte 99
  .byte 116
  .byte 111
  .byte 114
  .byte 95
  .byte 98
  .byte 115
  .byte 116
  .byte 111
  .byte 114
  .byte 101
  .byte 124
  .byte 115
  .byte 101
  .byte 99
  .byte 116
  .byte 111
  .byte 114
  .byte 45
  .byte 98
  .byte 117
  .byte 102
  .byte 102
  .byte 101
  .byte 114
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 115
  .byte 101
  .byte 99
  .byte 116
  .byte 111
  .byte 114
  .byte 95
  .byte 98
  .byte 117
  .byte 102
  .byte 124
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 45
  .byte 98
  .byte 117
  .byte 102
  .byte 102
  .byte 101
  .byte 114
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 95
  .byte 98
  .byte 117
  .byte 102
  .byte 102
  .byte 101
  .byte 114
  .byte 124
  .byte 102
  .byte 111
  .byte 110
  .byte 116
  .byte 45
  .byte 98
  .byte 97
  .byte 115
  .byte 101
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 102
  .byte 111
  .byte 110
  .byte 116
  .byte 95
  .byte 98
  .byte 97
  .byte 115
  .byte 101
  .byte 124
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 45
  .byte 98
  .byte 121
  .byte 116
  .byte 101
  .byte 33
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 95
  .byte 98
  .byte 115
  .byte 116
  .byte 111
  .byte 114
  .byte 101
  .byte 124
  .byte 98
  .byte 121
  .byte 116
  .byte 101
  .byte 64
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 98
  .byte 102
  .byte 101
  .byte 116
  .byte 99
  .byte 104
  .byte 124
  .byte 37
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 109
  .byte 111
  .byte 100
  .byte 124
  .byte 100
  .byte 105
  .byte 99
  .byte 116
  .byte 45
  .byte 104
  .byte 101
  .byte 97
  .byte 100
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 100
  .byte 105
  .byte 99
  .byte 116
  .byte 95
  .byte 104
  .byte 101
  .byte 97
  .byte 100
  .byte 124
  .byte 100
  .byte 105
  .byte 99
  .byte 116
  .byte 45
  .byte 110
  .byte 101
  .byte 120
  .byte 116
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 100
  .byte 105
  .byte 99
  .byte 116
  .byte 95
  .byte 110
  .byte 101
  .byte 120
  .byte 116
  .byte 124
  .byte 100
  .byte 105
  .byte 99
  .byte 116
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 100
  .byte 105
  .byte 99
  .byte 116
  .byte 95
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 124
  .byte 100
  .byte 105
  .byte 99
  .byte 116
  .byte 45
  .byte 99
  .byte 111
  .byte 100
  .byte 101
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 100
  .byte 105
  .byte 99
  .byte 116
  .byte 95
  .byte 99
  .byte 111
  .byte 100
  .byte 101
  .byte 124
  .byte 115
  .byte 50
  .byte 45
  .byte 116
  .byte 111
  .byte 107
  .byte 101
  .byte 110
  .byte 45
  .byte 98
  .byte 117
  .byte 102
  .byte 102
  .byte 101
  .byte 114
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 115
  .byte 50
  .byte 95
  .byte 116
  .byte 111
  .byte 107
  .byte 101
  .byte 110
  .byte 95
  .byte 98
  .byte 117
  .byte 102
  .byte 102
  .byte 101
  .byte 114
  .byte 124
  .byte 115
  .byte 50
  .byte 45
  .byte 108
  .byte 105
  .byte 110
  .byte 101
  .byte 45
  .byte 98
  .byte 117
  .byte 102
  .byte 102
  .byte 101
  .byte 114
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 115
  .byte 50
  .byte 95
  .byte 108
  .byte 105
  .byte 110
  .byte 101
  .byte 95
  .byte 98
  .byte 117
  .byte 102
  .byte 102
  .byte 101
  .byte 114
  .byte 124
  .byte 115
  .byte 50
  .byte 45
  .byte 99
  .byte 111
  .byte 110
  .byte 116
  .byte 114
  .byte 111
  .byte 108
  .byte 45
  .byte 98
  .byte 117
  .byte 102
  .byte 102
  .byte 101
  .byte 114
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 115
  .byte 50
  .byte 95
  .byte 99
  .byte 111
  .byte 110
  .byte 116
  .byte 114
  .byte 111
  .byte 108
  .byte 95
  .byte 98
  .byte 117
  .byte 102
  .byte 102
  .byte 101
  .byte 114
  .byte 124
  .byte 0
.section .text
  leaq .Laot_string_371(%rip), %rdi
  movq $1, %rsi
  call fr_push
  ret
fw_616f742d6f70732d74776f:
.section .rodata
.Laot_string_372:
  .byte 115
  .byte 50
  .byte 45
  .byte 99
  .byte 111
  .byte 100
  .byte 101
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 115
  .byte 50
  .byte 95
  .byte 99
  .byte 111
  .byte 100
  .byte 101
  .byte 124
  .byte 115
  .byte 50
  .byte 45
  .byte 114
  .byte 117
  .byte 110
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 115
  .byte 50
  .byte 95
  .byte 114
  .byte 117
  .byte 110
  .byte 124
  .byte 115
  .byte 50
  .byte 45
  .byte 100
  .byte 101
  .byte 102
  .byte 105
  .byte 110
  .byte 101
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 115
  .byte 50
  .byte 95
  .byte 100
  .byte 101
  .byte 102
  .byte 105
  .byte 110
  .byte 101
  .byte 124
  .byte 115
  .byte 50
  .byte 45
  .byte 105
  .byte 110
  .byte 116
  .byte 101
  .byte 114
  .byte 110
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 115
  .byte 50
  .byte 95
  .byte 105
  .byte 110
  .byte 116
  .byte 101
  .byte 114
  .byte 110
  .byte 124
  .byte 115
  .byte 50
  .byte 45
  .byte 108
  .byte 105
  .byte 116
  .byte 45
  .byte 97
  .byte 100
  .byte 100
  .byte 114
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 115
  .byte 50
  .byte 95
  .byte 108
  .byte 105
  .byte 116
  .byte 95
  .byte 97
  .byte 100
  .byte 100
  .byte 114
  .byte 124
  .byte 115
  .byte 50
  .byte 45
  .byte 115
  .byte 105
  .byte 103
  .byte 110
  .byte 45
  .byte 97
  .byte 100
  .byte 100
  .byte 114
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 115
  .byte 50
  .byte 95
  .byte 115
  .byte 105
  .byte 103
  .byte 110
  .byte 95
  .byte 97
  .byte 100
  .byte 100
  .byte 114
  .byte 124
  .byte 115
  .byte 50
  .byte 45
  .byte 115
  .byte 116
  .byte 114
  .byte 105
  .byte 110
  .byte 103
  .byte 45
  .byte 97
  .byte 100
  .byte 100
  .byte 114
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 115
  .byte 50
  .byte 95
  .byte 115
  .byte 116
  .byte 114
  .byte 105
  .byte 110
  .byte 103
  .byte 95
  .byte 97
  .byte 100
  .byte 100
  .byte 114
  .byte 124
  .byte 114
  .byte 101
  .byte 112
  .byte 108
  .byte 45
  .byte 98
  .byte 117
  .byte 102
  .byte 102
  .byte 101
  .byte 114
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 114
  .byte 101
  .byte 112
  .byte 108
  .byte 95
  .byte 98
  .byte 117
  .byte 102
  .byte 102
  .byte 101
  .byte 114
  .byte 124
  .byte 97
  .byte 108
  .byte 108
  .byte 111
  .byte 99
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 104
  .byte 101
  .byte 97
  .byte 112
  .byte 95
  .byte 97
  .byte 108
  .byte 108
  .byte 111
  .byte 99
  .byte 124
  .byte 104
  .byte 101
  .byte 97
  .byte 112
  .byte 45
  .byte 102
  .byte 114
  .byte 101
  .byte 101
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 104
  .byte 101
  .byte 97
  .byte 112
  .byte 95
  .byte 97
  .byte 118
  .byte 97
  .byte 105
  .byte 108
  .byte 97
  .byte 98
  .byte 108
  .byte 101
  .byte 124
  .byte 102
  .byte 105
  .byte 98
  .byte 101
  .byte 114
  .byte 45
  .byte 115
  .byte 112
  .byte 97
  .byte 119
  .byte 110
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 102
  .byte 105
  .byte 98
  .byte 101
  .byte 114
  .byte 95
  .byte 115
  .byte 112
  .byte 97
  .byte 119
  .byte 110
  .byte 124
  .byte 102
  .byte 105
  .byte 98
  .byte 101
  .byte 114
  .byte 45
  .byte 115
  .byte 116
  .byte 101
  .byte 112
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 102
  .byte 105
  .byte 98
  .byte 101
  .byte 114
  .byte 95
  .byte 115
  .byte 116
  .byte 101
  .byte 112
  .byte 124
  .byte 102
  .byte 105
  .byte 98
  .byte 101
  .byte 114
  .byte 45
  .byte 121
  .byte 105
  .byte 101
  .byte 108
  .byte 100
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 102
  .byte 105
  .byte 98
  .byte 101
  .byte 114
  .byte 95
  .byte 121
  .byte 105
  .byte 101
  .byte 108
  .byte 100
  .byte 124
  .byte 102
  .byte 105
  .byte 98
  .byte 101
  .byte 114
  .byte 45
  .byte 97
  .byte 99
  .byte 116
  .byte 105
  .byte 118
  .byte 101
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 102
  .byte 105
  .byte 98
  .byte 101
  .byte 114
  .byte 95
  .byte 97
  .byte 99
  .byte 116
  .byte 105
  .byte 118
  .byte 101
  .byte 124
  .byte 112
  .byte 97
  .byte 103
  .byte 101
  .byte 45
  .byte 97
  .byte 108
  .byte 108
  .byte 111
  .byte 99
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 112
  .byte 97
  .byte 103
  .byte 101
  .byte 95
  .byte 97
  .byte 108
  .byte 108
  .byte 111
  .byte 99
  .byte 124
  .byte 112
  .byte 97
  .byte 103
  .byte 101
  .byte 45
  .byte 102
  .byte 114
  .byte 101
  .byte 101
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 112
  .byte 97
  .byte 103
  .byte 101
  .byte 95
  .byte 102
  .byte 114
  .byte 101
  .byte 101
  .byte 124
  .byte 112
  .byte 97
  .byte 103
  .byte 101
  .byte 45
  .byte 102
  .byte 114
  .byte 101
  .byte 101
  .byte 45
  .byte 99
  .byte 111
  .byte 117
  .byte 110
  .byte 116
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 112
  .byte 97
  .byte 103
  .byte 101
  .byte 95
  .byte 102
  .byte 114
  .byte 101
  .byte 101
  .byte 95
  .byte 99
  .byte 111
  .byte 117
  .byte 110
  .byte 116
  .byte 124
  .byte 102
  .byte 116
  .byte 45
  .byte 115
  .byte 104
  .byte 97
  .byte 50
  .byte 53
  .byte 54
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 102
  .byte 116
  .byte 95
  .byte 115
  .byte 104
  .byte 97
  .byte 50
  .byte 53
  .byte 54
  .byte 124
  .byte 115
  .byte 104
  .byte 108
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 108
  .byte 115
  .byte 104
  .byte 105
  .byte 102
  .byte 116
  .byte 124
  .byte 115
  .byte 104
  .byte 114
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 114
  .byte 115
  .byte 104
  .byte 105
  .byte 102
  .byte 116
  .byte 124
  .byte 60
  .byte 60
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 108
  .byte 115
  .byte 104
  .byte 105
  .byte 102
  .byte 116
  .byte 124
  .byte 62
  .byte 62
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 114
  .byte 115
  .byte 104
  .byte 105
  .byte 102
  .byte 116
  .byte 124
  .byte 115
  .byte 50
  .byte 45
  .byte 115
  .byte 101
  .byte 108
  .byte 102
  .byte 45
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 115
  .byte 50
  .byte 95
  .byte 115
  .byte 101
  .byte 108
  .byte 102
  .byte 95
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 124
  .byte 33
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 98
  .byte 115
  .byte 116
  .byte 111
  .byte 114
  .byte 101
  .byte 124
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 98
  .byte 117
  .byte 110
  .byte 100
  .byte 108
  .byte 101
  .byte 45
  .byte 97
  .byte 114
  .byte 101
  .byte 97
  .byte 124
  .byte 102
  .byte 114
  .byte 95
  .byte 97
  .byte 111
  .byte 116
  .byte 95
  .byte 98
  .byte 117
  .byte 110
  .byte 100
  .byte 108
  .byte 101
  .byte 95
  .byte 97
  .byte 114
  .byte 101
  .byte 97
  .byte 124
  .byte 0
.section .text
  leaq .Laot_string_372(%rip), %rdi
  movq $1, %rsi
  call fr_push
  ret
fw_616f742d6669656c642d6571:
.comm reg_fw_6166652d6669656c64,16,16
  leaq reg_fw_6166652d6669656c64(%rip), %rdi
  call fr_reg_set
.comm reg_fw_6166652d74657874,16,16
  leaq reg_fw_6166652d74657874(%rip), %rdi
  call fr_reg_set
.Lfranc_373:
  leaq reg_fw_6166652d6669656c64(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
.comm reg_fw_6166652d62,16,16
  leaq reg_fw_6166652d62(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_6166652d62(%rip), %rdi
  call fr_reg_get
  movabsq $124, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_374
  leaq reg_fw_6166652d74657874(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_375
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  jmp .Lfranc_376
.Lfranc_375:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.Lfranc_376:
  ret
.Lfranc_374:
  leaq reg_fw_6166652d74657874(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
  leaq reg_fw_6166652d62(%rip), %rdi
  call fr_reg_get
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_377
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_377:
  leaq reg_fw_6166652d6669656c64(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_6166652d6669656c64,16,16
  leaq reg_fw_6166652d6669656c64(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_6166652d74657874(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_6166652d74657874,16,16
  leaq reg_fw_6166652d74657874(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_373
  ret
fw_616f742d6669656c642d656e64:
.comm reg_fw_61666e2d706f73,16,16
  leaq reg_fw_61666e2d706f73(%rip), %rdi
  call fr_reg_set
.Lfranc_378:
  leaq reg_fw_61666e2d706f73(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
.comm reg_fw_61666e2d62,16,16
  leaq reg_fw_61666e2d62(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_61666e2d62(%rip), %rdi
  call fr_reg_get
  movabsq $124, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_379
  leaq reg_fw_61666e2d706f73(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
  ret
.Lfranc_379:
  leaq reg_fw_61666e2d62(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_380
  leaq reg_fw_61666e2d706f73(%rip), %rdi
  call fr_reg_get
  ret
.Lfranc_380:
  leaq reg_fw_61666e2d706f73(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_61666e2d706f73,16,16
  leaq reg_fw_61666e2d706f73(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_378
  ret
fw_616f742d7072696e742d6669656c64:
.comm reg_fw_6170662d706f73,16,16
  leaq reg_fw_6170662d706f73(%rip), %rdi
  call fr_reg_set
.Lfranc_381:
  leaq reg_fw_6170662d706f73(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
.comm reg_fw_6170662d63,16,16
  leaq reg_fw_6170662d63(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_6170662d63(%rip), %rdi
  call fr_reg_get
  movabsq $124, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_382
  call fr_cr
  ret
.Lfranc_382:
  leaq reg_fw_6170662d63(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_383
  call fr_cr
  ret
.Lfranc_383:
  leaq reg_fw_6170662d63(%rip), %rdi
  call fr_reg_get
  call fr_emit
  leaq reg_fw_6170662d706f73(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_6170662d706f73,16,16
  leaq reg_fw_6170662d706f73(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_381
  ret
fw_616f742d6f702d6d6170:
.comm reg_fw_616f6d2d706f73,16,16
  leaq reg_fw_616f6d2d706f73(%rip), %rdi
  call fr_reg_set
.comm reg_fw_616f6d2d776f7264,16,16
  leaq reg_fw_616f6d2d776f7264(%rip), %rdi
  call fr_reg_set
.Lfranc_384:
  leaq reg_fw_616f6d2d706f73(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_385
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_385:
  leaq reg_fw_616f6d2d776f7264(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_616f6d2d706f73(%rip), %rdi
  call fr_reg_get
  call fw_616f742d6669656c642d6571
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_386
.section .rodata
.Laot_string_387:
  .byte 32
  .byte 32
  .byte 99
  .byte 97
  .byte 108
  .byte 108
  .byte 32
  .byte 0
.section .text
  leaq .Laot_string_387(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  leaq reg_fw_616f6d2d706f73(%rip), %rdi
  call fr_reg_get
  call fw_616f742d6669656c642d656e64
  call fw_616f742d7072696e742d6669656c64
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_386:
  leaq reg_fw_616f6d2d706f73(%rip), %rdi
  call fr_reg_get
  call fw_616f742d6669656c642d656e64
  call fw_616f742d6669656c642d656e64
.comm reg_fw_616f6d2d706f73,16,16
  leaq reg_fw_616f6d2d706f73(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_384
  ret
fw_616f742d6f70657261746f72:
.comm reg_fw_616f2d74,16,16
  leaq reg_fw_616f2d74(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_616f2d74(%rip), %rdi
  call fr_reg_get
  call fw_616f742d6f70732d6f6e65
  call fw_616f742d6f702d6d6170
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_388
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_388:
  leaq reg_fw_616f2d74(%rip), %rdi
  call fr_reg_get
  call fw_616f742d6f70732d74776f
  call fw_616f742d6f702d6d6170
  ret
fw_616f742d746f6b656e:
.comm reg_fw_61742d746f6b656e,16,16
  leaq reg_fw_61742d746f6b656e(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_61742d746f6b656e(%rip), %rdi
  call fr_reg_get
  call fw_616f742d6f70657261746f72
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_389
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_389:
  leaq reg_fw_61742d746f6b656e(%rip), %rdi
  call fr_reg_get
  call fw_73322d6e756d626572
.comm reg_fw_61742d76616c6964,16,16
  leaq reg_fw_61742d76616c6964(%rip), %rdi
  call fr_reg_set
.comm reg_fw_61742d64656e,16,16
  leaq reg_fw_61742d64656e(%rip), %rdi
  call fr_reg_set
.comm reg_fw_61742d6e756d,16,16
  leaq reg_fw_61742d6e756d(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_61742d76616c6964(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_390
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_390:
  leaq reg_fw_61742d6e756d(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_61742d64656e(%rip), %rdi
  call fr_reg_get
  call fw_616f742d6c69746572616c
  ret
fw_616f742d736f75726365:
.comm reg_fw_733270,16,16
  leaq reg_fw_733270(%rip), %rdi
  call fr_reg_set
.section .rodata
.Laot_string_391:
  .byte 70
  .byte 82
  .byte 65
  .byte 78
  .byte 67
  .byte 45
  .byte 65
  .byte 79
  .byte 84
  .byte 45
  .byte 66
  .byte 69
  .byte 71
  .byte 73
  .byte 78
  .byte 0
.section .text
  leaq .Laot_string_391(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  movabsq $10, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_emit
.section .rodata
.Laot_string_392:
  .byte 46
  .byte 116
  .byte 101
  .byte 120
  .byte 116
  .byte 0
.section .text
  leaq .Laot_string_392(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  movabsq $10, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_emit
.section .rodata
.Laot_string_393:
  .byte 46
  .byte 103
  .byte 108
  .byte 111
  .byte 98
  .byte 97
  .byte 108
  .byte 32
  .byte 102
  .byte 114
  .byte 97
  .byte 110
  .byte 99
  .byte 95
  .byte 97
  .byte 111
  .byte 116
  .byte 95
  .byte 101
  .byte 110
  .byte 116
  .byte 114
  .byte 121
  .byte 0
.section .text
  leaq .Laot_string_393(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  movabsq $10, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_emit
.section .rodata
.Laot_string_394:
  .byte 102
  .byte 114
  .byte 97
  .byte 110
  .byte 99
  .byte 95
  .byte 97
  .byte 111
  .byte 116
  .byte 95
  .byte 101
  .byte 110
  .byte 116
  .byte 114
  .byte 121
  .byte 58
  .byte 0
.section .text
  leaq .Laot_string_394(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  movabsq $10, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_emit
.Lfranc_395:
  call fw_73322d6e657874
.comm reg_fw_61742d6e657874,16,16
  leaq reg_fw_61742d6e657874(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_61742d6e657874(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_396
.section .rodata
.Laot_string_397:
  .byte 32
  .byte 32
  .byte 114
  .byte 101
  .byte 116
  .byte 0
.section .text
  leaq .Laot_string_397(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  movabsq $10, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_emit
.section .rodata
.Laot_string_398:
  .byte 70
  .byte 82
  .byte 65
  .byte 78
  .byte 67
  .byte 45
  .byte 65
  .byte 79
  .byte 84
  .byte 45
  .byte 69
  .byte 78
  .byte 68
  .byte 0
.section .text
  leaq .Laot_string_398(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  movabsq $10, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_emit
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_396:
  leaq reg_fw_61742d6e657874(%rip), %rdi
  call fr_reg_get
  call fw_616f742d746f6b656e
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_399
.section .rodata
.Laot_string_400:
  .byte 70
  .byte 82
  .byte 65
  .byte 78
  .byte 67
  .byte 45
  .byte 65
  .byte 79
  .byte 84
  .byte 45
  .byte 69
  .byte 82
  .byte 82
  .byte 79
  .byte 82
  .byte 0
.section .text
  leaq .Laot_string_400(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  movabsq $10, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_emit
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_399:
  jmp .Lfranc_395
  ret
fw_616f742d64656d6f:
.section .rodata
.Laot_string_401:
  .byte 50
  .byte 32
  .byte 51
  .byte 32
  .byte 43
  .byte 32
  .byte 46
  .byte 0
.section .text
  leaq .Laot_string_401(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_616f742d736f75726365
  call fr_drop
  ret
fw_616f742d6e6962626c65:
.comm reg_fw_616e2d6e,16,16
  leaq reg_fw_616e2d6e(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_616e2d6e(%rip), %rdi
  call fr_reg_get
  movabsq $10, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_402
  leaq reg_fw_616e2d6e(%rip), %rdi
  call fr_reg_get
  movabsq $48, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
  call fr_emit
  jmp .Lfranc_403
.Lfranc_402:
  leaq reg_fw_616e2d6e(%rip), %rdi
  call fr_reg_get
  movabsq $10, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  movabsq $97, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
  call fr_emit
.Lfranc_403:
  ret
fw_616f742d6e616d65:
.comm reg_fw_616e2d6e616d65,16,16
  leaq reg_fw_616e2d6e616d65(%rip), %rdi
  call fr_reg_set
.section .rodata
.Laot_string_404:
  .byte 102
  .byte 119
  .byte 95
  .byte 0
.section .text
  leaq .Laot_string_404(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
.Lfranc_405:
  leaq reg_fw_616e2d6e616d65(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
.comm reg_fw_616e2d62797465,16,16
  leaq reg_fw_616e2d62797465(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_616e2d62797465(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_406
  ret
.Lfranc_406:
  leaq reg_fw_616e2d62797465(%rip), %rdi
  call fr_reg_get
  movabsq $16, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_div
  call fr_floor
  call fw_616f742d6e6962626c65
  leaq reg_fw_616e2d62797465(%rip), %rdi
  call fr_reg_get
  movabsq $16, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_mod
  call fw_616f742d6e6962626c65
  leaq reg_fw_616e2d6e616d65(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_616e2d6e616d65,16,16
  leaq reg_fw_616e2d6e616d65(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_405
  ret
fw_616f742d63616c6c:
.comm reg_fw_61632d6e616d65,16,16
  leaq reg_fw_61632d6e616d65(%rip), %rdi
  call fr_reg_set
.section .rodata
.Laot_string_407:
  .byte 32
  .byte 32
  .byte 99
  .byte 97
  .byte 108
  .byte 108
  .byte 32
  .byte 0
.section .text
  leaq .Laot_string_407(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  leaq reg_fw_61632d6e616d65(%rip), %rdi
  call fr_reg_get
  call fw_616f742d6e616d65
  movabsq $10, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_emit
  ret
fw_616f742d70726f672d746f6b656e:
.comm reg_fw_6170742d746f6b656e,16,16
  leaq reg_fw_6170742d746f6b656e(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_6170742d746f6b656e(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
  movabsq $34, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_408
  leaq reg_fw_6170742d746f6b656e(%rip), %rdi
  call fr_reg_get
  call fw_616f742d737472696e67
  ret
.Lfranc_408:
  leaq reg_fw_6170742d746f6b656e(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
  movabsq $58, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_409
  leaq reg_fw_6170742d746f6b656e(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
  call fw_616f742d7265672d736574
  ret
.Lfranc_409:
  leaq reg_fw_6170742d746f6b656e(%rip), %rdi
  call fr_reg_get
  call fw_616f742d6f70657261746f72
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_410
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_410:
  leaq reg_fw_6170742d746f6b656e(%rip), %rdi
  call fr_reg_get
  call fw_73322d6e756d626572
.comm reg_fw_6170742d76616c6964,16,16
  leaq reg_fw_6170742d76616c6964(%rip), %rdi
  call fr_reg_set
.comm reg_fw_6170742d64656e,16,16
  leaq reg_fw_6170742d64656e(%rip), %rdi
  call fr_reg_set
.comm reg_fw_6170742d6e756d,16,16
  leaq reg_fw_6170742d6e756d(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_6170742d76616c6964(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_411
  leaq reg_fw_6170742d6e756d(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_6170742d64656e(%rip), %rdi
  call fr_reg_get
  call fw_616f742d6c69746572616c
  ret
.Lfranc_411:
  leaq reg_fw_6170742d746f6b656e(%rip), %rdi
  call fr_reg_get
  call fw_616f742d7265672d676574
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_412
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_412:
  leaq reg_fw_6170742d746f6b656e(%rip), %rdi
  call fr_reg_get
  call fw_616f742d63616c6c
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
fw_616f742d70726f6772616d:
.comm reg_fw_61702d696e707574,16,16
  leaq reg_fw_61702d696e707574(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_61702d696e707574(%rip), %rdi
  call fr_reg_get
.comm reg_fw_733270,16,16
  leaq reg_fw_733270(%rip), %rdi
  call fr_reg_set
.section .rodata
.Laot_string_413:
  .byte 70
  .byte 82
  .byte 65
  .byte 78
  .byte 67
  .byte 45
  .byte 80
  .byte 82
  .byte 79
  .byte 71
  .byte 82
  .byte 65
  .byte 77
  .byte 45
  .byte 66
  .byte 69
  .byte 71
  .byte 73
  .byte 78
  .byte 0
.section .text
  leaq .Laot_string_413(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
.section .rodata
.Laot_string_414:
  .byte 46
  .byte 116
  .byte 101
  .byte 120
  .byte 116
  .byte 0
.section .text
  leaq .Laot_string_414(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
.section .rodata
.Laot_string_415:
  .byte 46
  .byte 103
  .byte 108
  .byte 111
  .byte 98
  .byte 97
  .byte 108
  .byte 32
  .byte 102
  .byte 114
  .byte 97
  .byte 110
  .byte 99
  .byte 95
  .byte 97
  .byte 111
  .byte 116
  .byte 95
  .byte 101
  .byte 110
  .byte 116
  .byte 114
  .byte 121
  .byte 0
.section .text
  leaq .Laot_string_415(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
.section .rodata
.Laot_string_416:
  .byte 102
  .byte 114
  .byte 97
  .byte 110
  .byte 99
  .byte 95
  .byte 97
  .byte 111
  .byte 116
  .byte 95
  .byte 101
  .byte 110
  .byte 116
  .byte 114
  .byte 121
  .byte 58
  .byte 0
.section .text
  leaq .Laot_string_416(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  leaq reg_fw_616f742d6b65726e656c2d6d6f6465(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_417
.section .rodata
.Laot_string_418:
  .byte 46
  .byte 103
  .byte 108
  .byte 111
  .byte 98
  .byte 97
  .byte 108
  .byte 32
  .byte 102
  .byte 114
  .byte 97
  .byte 110
  .byte 99
  .byte 95
  .byte 101
  .byte 110
  .byte 116
  .byte 114
  .byte 121
  .byte 0
.section .text
  leaq .Laot_string_418(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
.section .rodata
.Laot_string_419:
  .byte 102
  .byte 114
  .byte 97
  .byte 110
  .byte 99
  .byte 95
  .byte 101
  .byte 110
  .byte 116
  .byte 114
  .byte 121
  .byte 58
  .byte 0
.section .text
  leaq .Laot_string_419(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
.Lfranc_417:
  leaq reg_fw_616f742d6b65726e656c2d6d6f6465(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_420
.section .rodata
.Laot_string_421:
  .byte 98
  .byte 111
  .byte 111
  .byte 116
  .byte 0
.section .text
  leaq .Laot_string_421(%rip), %rdi
  movq $1, %rsi
  call fr_push
  jmp .Lfranc_422
.Lfranc_420:
.section .rodata
.Laot_string_423:
  .byte 109
  .byte 97
  .byte 105
  .byte 110
  .byte 0
.section .text
  leaq .Laot_string_423(%rip), %rdi
  movq $1, %rsi
  call fr_push
.Lfranc_422:
  call fw_616f742d63616c6c
.section .rodata
.Laot_string_424:
  .byte 32
  .byte 32
  .byte 114
  .byte 101
  .byte 116
  .byte 0
.section .text
  leaq .Laot_string_424(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_61702d696e2d646566,16,16
  leaq reg_fw_61702d696e2d646566(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_73327370,16,16
  leaq reg_fw_73327370(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_61632d6e6578742d6964,16,16
  leaq reg_fw_61632d6e6578742d6964(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_733270(%rip), %rdi
  call fr_reg_get
  call fw_616f742d7265672d7363616e
  leaq reg_fw_61702d696e707574(%rip), %rdi
  call fr_reg_get
.comm reg_fw_733270,16,16
  leaq reg_fw_733270(%rip), %rdi
  call fr_reg_set
.Lfranc_425:
  call fw_616f742d6e657874
.comm reg_fw_61702d746f6b656e,16,16
  leaq reg_fw_61702d746f6b656e(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_61702d746f6b656e(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_426
  leaq reg_fw_61702d696e2d646566(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_427
.section .rodata
.Laot_string_428:
  .byte 70
  .byte 82
  .byte 65
  .byte 78
  .byte 67
  .byte 45
  .byte 80
  .byte 82
  .byte 79
  .byte 71
  .byte 82
  .byte 65
  .byte 77
  .byte 45
  .byte 69
  .byte 82
  .byte 82
  .byte 79
  .byte 82
  .byte 0
.section .text
  leaq .Laot_string_428(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_427:
  leaq reg_fw_616f742d6b65726e656c2d6d6f6465(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_429
  leaq reg_fw_61702d696e707574(%rip), %rdi
  call fr_reg_get
  call fw_616f742d656d69742d6b65726e656c2d6d65746164617461
.Lfranc_429:
.section .rodata
.Laot_string_430:
  .byte 70
  .byte 82
  .byte 65
  .byte 78
  .byte 67
  .byte 45
  .byte 80
  .byte 82
  .byte 79
  .byte 71
  .byte 82
  .byte 65
  .byte 77
  .byte 45
  .byte 69
  .byte 78
  .byte 68
  .byte 0
.section .text
  leaq .Laot_string_430(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_426:
  leaq reg_fw_61702d746f6b656e(%rip), %rdi
  call fr_reg_get
.section .rodata
.Laot_string_431:
  .byte 100
  .byte 101
  .byte 102
  .byte 0
.section .text
  leaq .Laot_string_431(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d6571
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_432
  leaq reg_fw_61702d696e2d646566(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_433
.section .rodata
.Laot_string_434:
  .byte 70
  .byte 82
  .byte 65
  .byte 78
  .byte 67
  .byte 45
  .byte 80
  .byte 82
  .byte 79
  .byte 71
  .byte 82
  .byte 65
  .byte 77
  .byte 45
  .byte 69
  .byte 82
  .byte 82
  .byte 79
  .byte 82
  .byte 0
.section .text
  leaq .Laot_string_434(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_433:
  call fw_616f742d6e657874
.comm reg_fw_61702d6e616d65,16,16
  leaq reg_fw_61702d6e616d65(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_61702d6e616d65(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_435
.section .rodata
.Laot_string_436:
  .byte 70
  .byte 82
  .byte 65
  .byte 78
  .byte 67
  .byte 45
  .byte 80
  .byte 82
  .byte 79
  .byte 71
  .byte 82
  .byte 65
  .byte 77
  .byte 45
  .byte 69
  .byte 82
  .byte 82
  .byte 79
  .byte 82
  .byte 0
.section .text
  leaq .Laot_string_436(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_435:
  leaq reg_fw_61702d6e616d65(%rip), %rdi
  call fr_reg_get
  call fw_616f742d6e616d65
.section .rodata
.Laot_string_437:
  .byte 58
  .byte 0
.section .text
  leaq .Laot_string_437(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_61702d696e2d646566,16,16
  leaq reg_fw_61702d696e2d646566(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_438
.Lfranc_432:
  leaq reg_fw_61702d746f6b656e(%rip), %rdi
  call fr_reg_get
.section .rodata
.Laot_string_439:
  .byte 59
  .byte 0
.section .text
  leaq .Laot_string_439(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d6571
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_440
  leaq reg_fw_61702d696e2d646566(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_441
.section .rodata
.Laot_string_442:
  .byte 70
  .byte 82
  .byte 65
  .byte 78
  .byte 67
  .byte 45
  .byte 80
  .byte 82
  .byte 79
  .byte 71
  .byte 82
  .byte 65
  .byte 77
  .byte 45
  .byte 69
  .byte 82
  .byte 82
  .byte 79
  .byte 82
  .byte 0
.section .text
  leaq .Laot_string_442(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_441:
  leaq reg_fw_73327370(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_443
.section .rodata
.Laot_string_444:
  .byte 70
  .byte 82
  .byte 65
  .byte 78
  .byte 67
  .byte 45
  .byte 80
  .byte 82
  .byte 79
  .byte 71
  .byte 82
  .byte 65
  .byte 77
  .byte 45
  .byte 69
  .byte 82
  .byte 82
  .byte 79
  .byte 82
  .byte 0
.section .text
  leaq .Laot_string_444(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_443:
.section .rodata
.Laot_string_445:
  .byte 32
  .byte 32
  .byte 114
  .byte 101
  .byte 116
  .byte 0
.section .text
  leaq .Laot_string_445(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_61702d696e2d646566,16,16
  leaq reg_fw_61702d696e2d646566(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_446
.Lfranc_440:
  leaq reg_fw_61702d696e2d646566(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_447
.section .rodata
.Laot_string_448:
  .byte 70
  .byte 82
  .byte 65
  .byte 78
  .byte 67
  .byte 45
  .byte 80
  .byte 82
  .byte 79
  .byte 71
  .byte 82
  .byte 65
  .byte 77
  .byte 45
  .byte 69
  .byte 82
  .byte 82
  .byte 79
  .byte 82
  .byte 0
.section .text
  leaq .Laot_string_448(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_447:
  leaq reg_fw_61702d746f6b656e(%rip), %rdi
  call fr_reg_get
  call fw_616f742d70726f6772616d2d776f7264
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_449
.section .rodata
.Laot_string_450:
  .byte 70
  .byte 82
  .byte 65
  .byte 78
  .byte 67
  .byte 45
  .byte 80
  .byte 82
  .byte 79
  .byte 71
  .byte 82
  .byte 65
  .byte 77
  .byte 45
  .byte 69
  .byte 82
  .byte 82
  .byte 79
  .byte 82
  .byte 0
.section .text
  leaq .Laot_string_450(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_449:
.Lfranc_446:
.Lfranc_438:
  jmp .Lfranc_425
  ret
fw_616f742d70726f6772616d2d64656d6f:
.section .rodata
.Laot_string_451:
  .byte 100
  .byte 101
  .byte 102
  .byte 32
  .byte 115
  .byte 113
  .byte 117
  .byte 97
  .byte 114
  .byte 101
  .byte 32
  .byte 100
  .byte 117
  .byte 112
  .byte 32
  .byte 42
  .byte 32
  .byte 59
  .byte 10
  .byte 100
  .byte 101
  .byte 102
  .byte 32
  .byte 109
  .byte 97
  .byte 105
  .byte 110
  .byte 32
  .byte 55
  .byte 32
  .byte 115
  .byte 113
  .byte 117
  .byte 97
  .byte 114
  .byte 101
  .byte 32
  .byte 46
  .byte 32
  .byte 59
  .byte 0
.section .text
  leaq .Laot_string_451(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_616f742d70726f6772616d
  call fr_drop
  ret
fw_616f742d6964:
  leaq reg_fw_61632d6e6578742d6964(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_61632d6e6578742d6964,16,16
  leaq reg_fw_61632d6e6578742d6964(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_61632d6e6578742d6964(%rip), %rdi
  call fr_reg_get
  ret
fw_616f742d6c6162656c:
.comm reg_fw_61632d6964,16,16
  leaq reg_fw_61632d6964(%rip), %rdi
  call fr_reg_set
.section .rodata
.Laot_string_452:
  .byte 46
  .byte 76
  .byte 102
  .byte 114
  .byte 97
  .byte 110
  .byte 99
  .byte 95
  .byte 0
.section .text
  leaq .Laot_string_452(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  leaq reg_fw_61632d6964(%rip), %rdi
  call fr_reg_get
  call fw_616f742d646563
  ret
fw_616f742d6d61726b:
.comm reg_fw_61632d6964,16,16
  leaq reg_fw_61632d6964(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_61632d6964(%rip), %rdi
  call fr_reg_get
  call fw_616f742d6c6162656c
.section .rodata
.Laot_string_453:
  .byte 58
  .byte 0
.section .text
  leaq .Laot_string_453(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  ret
fw_616f742d6a756d70:
.comm reg_fw_61632d746172676574,16,16
  leaq reg_fw_61632d746172676574(%rip), %rdi
  call fr_reg_set
.comm reg_fw_61632d6f70,16,16
  leaq reg_fw_61632d6f70(%rip), %rdi
  call fr_reg_set
.section .rodata
.Laot_string_454:
  .byte 32
  .byte 32
  .byte 0
.section .text
  leaq .Laot_string_454(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  leaq reg_fw_61632d6f70(%rip), %rdi
  call fr_reg_get
  call fr_type
.section .rodata
.Laot_string_455:
  .byte 32
  .byte 0
.section .text
  leaq .Laot_string_455(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  leaq reg_fw_61632d746172676574(%rip), %rdi
  call fr_reg_get
  call fw_616f742d6c6162656c
  movabsq $10, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_emit
  ret
fw_616f742d6966:
.comm reg_fw_61692d6f70,16,16
  leaq reg_fw_61692d6f70(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_73327370(%rip), %rdi
  call fr_reg_get
  movabsq $63, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_456
  movabsq $-1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_456:
  call fw_616f742d6964
.comm reg_fw_61692d6964,16,16
  leaq reg_fw_61692d6964(%rip), %rdi
  call fr_reg_set
.section .rodata
.Laot_string_457:
  .byte 32
  .byte 32
  .byte 99
  .byte 97
  .byte 108
  .byte 108
  .byte 32
  .byte 102
  .byte 114
  .byte 95
  .byte 99
  .byte 111
  .byte 110
  .byte 100
  .byte 105
  .byte 116
  .byte 105
  .byte 111
  .byte 110
  .byte 0
.section .text
  leaq .Laot_string_457(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
.section .rodata
.Laot_string_458:
  .byte 32
  .byte 32
  .byte 116
  .byte 101
  .byte 115
  .byte 116
  .byte 113
  .byte 32
  .byte 37
  .byte 114
  .byte 97
  .byte 120
  .byte 44
  .byte 32
  .byte 37
  .byte 114
  .byte 97
  .byte 120
  .byte 0
.section .text
  leaq .Laot_string_458(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  leaq reg_fw_61692d6f70(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_61692d6964(%rip), %rdi
  call fr_reg_get
  call fw_616f742d6a756d70
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  leaq reg_fw_61692d6964(%rip), %rdi
  call fr_reg_get
  call fw_73322d6374726c2d70757368
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_459
  movabsq $-1, %rdi
  movabsq $1, %rsi
  call fr_push
  jmp .Lfranc_460
.Lfranc_459:
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
.Lfranc_460:
  ret
fw_616f742d626567696e:
  leaq reg_fw_73327370(%rip), %rdi
  call fr_reg_get
  movabsq $63, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_461
  movabsq $-1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_461:
  call fw_616f742d6964
.comm reg_fw_61622d6964,16,16
  leaq reg_fw_61622d6964(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_61622d6964(%rip), %rdi
  call fr_reg_get
  call fw_616f742d6d61726b
  movabsq $3, %rdi
  movabsq $1, %rsi
  call fr_push
  leaq reg_fw_61622d6964(%rip), %rdi
  call fr_reg_get
  call fw_73322d6374726c2d70757368
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_462
  movabsq $-1, %rdi
  movabsq $1, %rsi
  call fr_push
  jmp .Lfranc_463
.Lfranc_462:
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
.Lfranc_463:
  ret
fw_616f742d656c7365:
  leaq reg_fw_73327370(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_464
  movabsq $-1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_464:
  call fw_73322d6374726c2d706f70
.comm reg_fw_61652d6f6c64,16,16
  leaq reg_fw_61652d6f6c64(%rip), %rdi
  call fr_reg_set
.comm reg_fw_61652d746167,16,16
  leaq reg_fw_61652d746167(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_61652d746167(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_465
  movabsq $-1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_465:
  call fw_616f742d6964
.comm reg_fw_61652d656e64,16,16
  leaq reg_fw_61652d656e64(%rip), %rdi
  call fr_reg_set
.section .rodata
.Laot_string_466:
  .byte 106
  .byte 109
  .byte 112
  .byte 0
.section .text
  leaq .Laot_string_466(%rip), %rdi
  movq $1, %rsi
  call fr_push
  leaq reg_fw_61652d656e64(%rip), %rdi
  call fr_reg_get
  call fw_616f742d6a756d70
  leaq reg_fw_61652d6f6c64(%rip), %rdi
  call fr_reg_get
  call fw_616f742d6d61726b
  movabsq $2, %rdi
  movabsq $1, %rsi
  call fr_push
  leaq reg_fw_61652d656e64(%rip), %rdi
  call fr_reg_get
  call fw_73322d6374726c2d70757368
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_467
  movabsq $-1, %rdi
  movabsq $1, %rsi
  call fr_push
  jmp .Lfranc_468
.Lfranc_467:
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
.Lfranc_468:
  ret
fw_616f742d7468656e:
  leaq reg_fw_73327370(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_469
  movabsq $-1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_469:
  call fw_73322d6374726c2d706f70
.comm reg_fw_61742d6964,16,16
  leaq reg_fw_61742d6964(%rip), %rdi
  call fr_reg_set
.comm reg_fw_61742d746167,16,16
  leaq reg_fw_61742d746167(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_61742d746167(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_470
  leaq reg_fw_61742d6964(%rip), %rdi
  call fr_reg_get
  call fw_616f742d6d61726b
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_470:
  leaq reg_fw_61742d746167(%rip), %rdi
  call fr_reg_get
  movabsq $2, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_471
  leaq reg_fw_61742d6964(%rip), %rdi
  call fr_reg_get
  call fw_616f742d6d61726b
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_471:
  movabsq $-1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
fw_616f742d7768696c65:
  leaq reg_fw_73327370(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_472
  movabsq $-1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_472:
  call fw_73322d6374726c2d706f70
.comm reg_fw_61772d626567696e,16,16
  leaq reg_fw_61772d626567696e(%rip), %rdi
  call fr_reg_set
.comm reg_fw_61772d746167,16,16
  leaq reg_fw_61772d746167(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_61772d746167(%rip), %rdi
  call fr_reg_get
  movabsq $3, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_473
  movabsq $-1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_473:
  movabsq $3, %rdi
  movabsq $1, %rsi
  call fr_push
  leaq reg_fw_61772d626567696e(%rip), %rdi
  call fr_reg_get
  call fw_73322d6374726c2d70757368
  call fr_drop
  call fw_616f742d6964
.comm reg_fw_61772d656e64,16,16
  leaq reg_fw_61772d656e64(%rip), %rdi
  call fr_reg_set
.section .rodata
.Laot_string_474:
  .byte 32
  .byte 32
  .byte 99
  .byte 97
  .byte 108
  .byte 108
  .byte 32
  .byte 102
  .byte 114
  .byte 95
  .byte 99
  .byte 111
  .byte 110
  .byte 100
  .byte 105
  .byte 116
  .byte 105
  .byte 111
  .byte 110
  .byte 0
.section .text
  leaq .Laot_string_474(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
.section .rodata
.Laot_string_475:
  .byte 32
  .byte 32
  .byte 116
  .byte 101
  .byte 115
  .byte 116
  .byte 113
  .byte 32
  .byte 37
  .byte 114
  .byte 97
  .byte 120
  .byte 44
  .byte 32
  .byte 37
  .byte 114
  .byte 97
  .byte 120
  .byte 0
.section .text
  leaq .Laot_string_475(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
.section .rodata
.Laot_string_476:
  .byte 106
  .byte 110
  .byte 115
  .byte 0
.section .text
  leaq .Laot_string_476(%rip), %rdi
  movq $1, %rsi
  call fr_push
  leaq reg_fw_61772d656e64(%rip), %rdi
  call fr_reg_get
  call fw_616f742d6a756d70
  movabsq $4, %rdi
  movabsq $1, %rsi
  call fr_push
  leaq reg_fw_61772d656e64(%rip), %rdi
  call fr_reg_get
  call fw_73322d6374726c2d70757368
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_477
  movabsq $-1, %rdi
  movabsq $1, %rsi
  call fr_push
  jmp .Lfranc_478
.Lfranc_477:
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
.Lfranc_478:
  ret
fw_616f742d616761696e:
  leaq reg_fw_73327370(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_479
  movabsq $-1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_479:
  call fw_73322d6374726c2d706f70
.comm reg_fw_61612d7374617274,16,16
  leaq reg_fw_61612d7374617274(%rip), %rdi
  call fr_reg_set
.comm reg_fw_61612d746167,16,16
  leaq reg_fw_61612d746167(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_61612d746167(%rip), %rdi
  call fr_reg_get
  movabsq $3, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_480
  movabsq $-1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_480:
.section .rodata
.Laot_string_481:
  .byte 106
  .byte 109
  .byte 112
  .byte 0
.section .text
  leaq .Laot_string_481(%rip), %rdi
  movq $1, %rsi
  call fr_push
  leaq reg_fw_61612d7374617274(%rip), %rdi
  call fr_reg_get
  call fw_616f742d6a756d70
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
fw_616f742d726570656174:
  leaq reg_fw_73327370(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_482
  movabsq $-1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_482:
  call fw_73322d6374726c2d706f70
.comm reg_fw_61722d656e64,16,16
  leaq reg_fw_61722d656e64(%rip), %rdi
  call fr_reg_set
.comm reg_fw_61722d746167,16,16
  leaq reg_fw_61722d746167(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_61722d746167(%rip), %rdi
  call fr_reg_get
  movabsq $4, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_483
  movabsq $-1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_483:
  leaq reg_fw_73327370(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_484
  movabsq $-1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_484:
  call fw_73322d6374726c2d706f70
.comm reg_fw_61722d7374617274,16,16
  leaq reg_fw_61722d7374617274(%rip), %rdi
  call fr_reg_set
.comm reg_fw_61722d62746167,16,16
  leaq reg_fw_61722d62746167(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_61722d62746167(%rip), %rdi
  call fr_reg_get
  movabsq $3, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_485
  movabsq $-1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_485:
.section .rodata
.Laot_string_486:
  .byte 106
  .byte 109
  .byte 112
  .byte 0
.section .text
  leaq .Laot_string_486(%rip), %rdi
  movq $1, %rsi
  call fr_push
  leaq reg_fw_61722d7374617274(%rip), %rdi
  call fr_reg_get
  call fw_616f742d6a756d70
  leaq reg_fw_61722d656e64(%rip), %rdi
  call fr_reg_get
  call fw_616f742d6d61726b
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
fw_616f742d636f6e74726f6c:
.comm reg_fw_6163742d74,16,16
  leaq reg_fw_6163742d74(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_6163742d74(%rip), %rdi
  call fr_reg_get
.section .rodata
.Laot_string_487:
  .byte 105
  .byte 102
  .byte 0
.section .text
  leaq .Laot_string_487(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d6571
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_488
.section .rodata
.Laot_string_489:
  .byte 106
  .byte 110
  .byte 115
  .byte 0
.section .text
  leaq .Laot_string_489(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_616f742d6966
  ret
.Lfranc_488:
  leaq reg_fw_6163742d74(%rip), %rdi
  call fr_reg_get
.section .rodata
.Laot_string_490:
  .byte 105
  .byte 102
  .byte 48
  .byte 0
.section .text
  leaq .Laot_string_490(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d6571
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_491
.section .rodata
.Laot_string_492:
  .byte 106
  .byte 110
  .byte 122
  .byte 0
.section .text
  leaq .Laot_string_492(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_616f742d6966
  ret
.Lfranc_491:
  leaq reg_fw_6163742d74(%rip), %rdi
  call fr_reg_get
.section .rodata
.Laot_string_493:
  .byte 105
  .byte 102
  .byte 110
  .byte 122
  .byte 0
.section .text
  leaq .Laot_string_493(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d6571
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_494
.section .rodata
.Laot_string_495:
  .byte 106
  .byte 122
  .byte 0
.section .text
  leaq .Laot_string_495(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_616f742d6966
  ret
.Lfranc_494:
  leaq reg_fw_6163742d74(%rip), %rdi
  call fr_reg_get
.section .rodata
.Laot_string_496:
  .byte 101
  .byte 108
  .byte 115
  .byte 101
  .byte 0
.section .text
  leaq .Laot_string_496(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d6571
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_497
  call fw_616f742d656c7365
  ret
.Lfranc_497:
  leaq reg_fw_6163742d74(%rip), %rdi
  call fr_reg_get
.section .rodata
.Laot_string_498:
  .byte 116
  .byte 104
  .byte 101
  .byte 110
  .byte 0
.section .text
  leaq .Laot_string_498(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d6571
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_499
  call fw_616f742d7468656e
  ret
.Lfranc_499:
  leaq reg_fw_6163742d74(%rip), %rdi
  call fr_reg_get
.section .rodata
.Laot_string_500:
  .byte 98
  .byte 101
  .byte 103
  .byte 105
  .byte 110
  .byte 0
.section .text
  leaq .Laot_string_500(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d6571
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_501
  call fw_616f742d626567696e
  ret
.Lfranc_501:
  leaq reg_fw_6163742d74(%rip), %rdi
  call fr_reg_get
.section .rodata
.Laot_string_502:
  .byte 119
  .byte 104
  .byte 105
  .byte 108
  .byte 101
  .byte 0
.section .text
  leaq .Laot_string_502(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d6571
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_503
  call fw_616f742d7768696c65
  ret
.Lfranc_503:
  leaq reg_fw_6163742d74(%rip), %rdi
  call fr_reg_get
.section .rodata
.Laot_string_504:
  .byte 97
  .byte 103
  .byte 97
  .byte 105
  .byte 110
  .byte 0
.section .text
  leaq .Laot_string_504(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d6571
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_505
  call fw_616f742d616761696e
  ret
.Lfranc_505:
  leaq reg_fw_6163742d74(%rip), %rdi
  call fr_reg_get
.section .rodata
.Laot_string_506:
  .byte 114
  .byte 101
  .byte 112
  .byte 101
  .byte 97
  .byte 116
  .byte 0
.section .text
  leaq .Laot_string_506(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d6571
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_507
  call fw_616f742d726570656174
  ret
.Lfranc_507:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
fw_616f742d70726f6772616d2d776f7264:
.comm reg_fw_6170772d746f6b656e,16,16
  leaq reg_fw_6170772d746f6b656e(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_6170772d746f6b656e(%rip), %rdi
  call fr_reg_get
  call fw_616f742d636f6e74726f6c
.comm reg_fw_6170772d737461747573,16,16
  leaq reg_fw_6170772d737461747573(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_6170772d737461747573(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_508
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_508:
  leaq reg_fw_6170772d737461747573(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_509
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_509:
  leaq reg_fw_6170772d746f6b656e(%rip), %rdi
  call fr_reg_get
.section .rodata
.Laot_string_510:
  .byte 101
  .byte 120
  .byte 105
  .byte 116
  .byte 0
.section .text
  leaq .Laot_string_510(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d6571
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_511
.section .rodata
.Laot_string_512:
  .byte 32
  .byte 32
  .byte 114
  .byte 101
  .byte 116
  .byte 0
.section .text
  leaq .Laot_string_512(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_511:
  leaq reg_fw_6170772d746f6b656e(%rip), %rdi
  call fr_reg_get
  call fw_616f742d70726f672d746f6b656e
  ret
fw_616f742d636f6e74726f6c2d64656d6f:
.section .rodata
.Laot_string_513:
  .byte 100
  .byte 101
  .byte 102
  .byte 32
  .byte 99
  .byte 104
  .byte 111
  .byte 111
  .byte 115
  .byte 101
  .byte 32
  .byte 100
  .byte 117
  .byte 112
  .byte 32
  .byte 48
  .byte 32
  .byte 45
  .byte 32
  .byte 105
  .byte 102
  .byte 32
  .byte 100
  .byte 114
  .byte 111
  .byte 112
  .byte 32
  .byte 49
  .byte 49
  .byte 32
  .byte 101
  .byte 108
  .byte 115
  .byte 101
  .byte 32
  .byte 100
  .byte 114
  .byte 111
  .byte 112
  .byte 32
  .byte 50
  .byte 50
  .byte 32
  .byte 116
  .byte 104
  .byte 101
  .byte 110
  .byte 32
  .byte 59
  .byte 10
  .byte 100
  .byte 101
  .byte 102
  .byte 32
  .byte 109
  .byte 97
  .byte 105
  .byte 110
  .byte 32
  .byte 45
  .byte 49
  .byte 32
  .byte 99
  .byte 104
  .byte 111
  .byte 111
  .byte 115
  .byte 101
  .byte 32
  .byte 46
  .byte 32
  .byte 49
  .byte 32
  .byte 99
  .byte 104
  .byte 111
  .byte 111
  .byte 115
  .byte 101
  .byte 32
  .byte 46
  .byte 32
  .byte 59
  .byte 0
.section .text
  leaq .Laot_string_513(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_616f742d70726f6772616d
  call fr_drop
.section .rodata
.Laot_string_514:
  .byte 70
  .byte 82
  .byte 65
  .byte 78
  .byte 67
  .byte 45
  .byte 67
  .byte 79
  .byte 78
  .byte 84
  .byte 82
  .byte 79
  .byte 76
  .byte 45
  .byte 69
  .byte 78
  .byte 68
  .byte 0
.section .text
  leaq .Laot_string_514(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  ret
fw_616f742d646174612d62797465:
.comm reg_fw_6164622d6e,16,16
  leaq reg_fw_6164622d6e(%rip), %rdi
  call fr_reg_set
.section .rodata
.Laot_string_515:
  .byte 32
  .byte 32
  .byte 46
  .byte 98
  .byte 121
  .byte 116
  .byte 101
  .byte 32
  .byte 0
.section .text
  leaq .Laot_string_515(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  leaq reg_fw_6164622d6e(%rip), %rdi
  call fr_reg_get
  call fw_616f742d646563
  call fr_cr
  ret
fw_616f742d7374722d6c6162656c:
.comm reg_fw_61736c2d6964,16,16
  leaq reg_fw_61736c2d6964(%rip), %rdi
  call fr_reg_set
.section .rodata
.Laot_string_516:
  .byte 46
  .byte 76
  .byte 97
  .byte 111
  .byte 116
  .byte 95
  .byte 115
  .byte 116
  .byte 114
  .byte 105
  .byte 110
  .byte 103
  .byte 95
  .byte 0
.section .text
  leaq .Laot_string_516(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  leaq reg_fw_61736c2d6964(%rip), %rdi
  call fr_reg_get
  call fw_616f742d646563
  ret
fw_616f742d737472696e67:
.comm reg_fw_617374722d74657874,16,16
  leaq reg_fw_617374722d74657874(%rip), %rdi
  call fr_reg_set
  call fw_616f742d6964
.comm reg_fw_617374722d6964,16,16
  leaq reg_fw_617374722d6964(%rip), %rdi
  call fr_reg_set
.section .rodata
.Laot_string_517:
  .byte 46
  .byte 115
  .byte 101
  .byte 99
  .byte 116
  .byte 105
  .byte 111
  .byte 110
  .byte 32
  .byte 46
  .byte 114
  .byte 111
  .byte 100
  .byte 97
  .byte 116
  .byte 97
  .byte 0
.section .text
  leaq .Laot_string_517(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  leaq reg_fw_617374722d6964(%rip), %rdi
  call fr_reg_get
  call fw_616f742d7374722d6c6162656c
.section .rodata
.Laot_string_518:
  .byte 58
  .byte 0
.section .text
  leaq .Laot_string_518(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  leaq reg_fw_617374722d74657874(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_617374722d706f73,16,16
  leaq reg_fw_617374722d706f73(%rip), %rdi
  call fr_reg_set
.Lfranc_519:
  leaq reg_fw_617374722d706f73(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
.comm reg_fw_617374722d62797465,16,16
  leaq reg_fw_617374722d62797465(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_617374722d62797465(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_520
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_520:
  leaq reg_fw_617374722d62797465(%rip), %rdi
  call fr_reg_get
  movabsq $34, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_521
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_616f742d646174612d62797465
.section .rodata
.Laot_string_522:
  .byte 46
  .byte 115
  .byte 101
  .byte 99
  .byte 116
  .byte 105
  .byte 111
  .byte 110
  .byte 32
  .byte 46
  .byte 116
  .byte 101
  .byte 120
  .byte 116
  .byte 0
.section .text
  leaq .Laot_string_522(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
.section .rodata
.Laot_string_523:
  .byte 32
  .byte 32
  .byte 108
  .byte 101
  .byte 97
  .byte 113
  .byte 32
  .byte 0
.section .text
  leaq .Laot_string_523(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  leaq reg_fw_617374722d6964(%rip), %rdi
  call fr_reg_get
  call fw_616f742d7374722d6c6162656c
.section .rodata
.Laot_string_524:
  .byte 40
  .byte 37
  .byte 114
  .byte 105
  .byte 112
  .byte 41
  .byte 44
  .byte 32
  .byte 37
  .byte 114
  .byte 100
  .byte 105
  .byte 0
.section .text
  leaq .Laot_string_524(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
.section .rodata
.Laot_string_525:
  .byte 32
  .byte 32
  .byte 109
  .byte 111
  .byte 118
  .byte 113
  .byte 32
  .byte 36
  .byte 49
  .byte 44
  .byte 32
  .byte 37
  .byte 114
  .byte 115
  .byte 105
  .byte 0
.section .text
  leaq .Laot_string_525(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
.section .rodata
.Laot_string_526:
  .byte 32
  .byte 32
  .byte 99
  .byte 97
  .byte 108
  .byte 108
  .byte 32
  .byte 102
  .byte 114
  .byte 95
  .byte 112
  .byte 117
  .byte 115
  .byte 104
  .byte 0
.section .text
  leaq .Laot_string_526(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_521:
  leaq reg_fw_617374722d62797465(%rip), %rdi
  call fr_reg_get
  movabsq $92, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_527
  leaq reg_fw_617374722d706f73(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_617374722d706f73,16,16
  leaq reg_fw_617374722d706f73(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_617374722d706f73(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
.comm reg_fw_617374722d62797465,16,16
  leaq reg_fw_617374722d62797465(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_617374722d62797465(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_528
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_528:
  leaq reg_fw_617374722d62797465(%rip), %rdi
  call fr_reg_get
  movabsq $110, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_529
  movabsq $10, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_617374722d62797465,16,16
  leaq reg_fw_617374722d62797465(%rip), %rdi
  call fr_reg_set
.Lfranc_529:
  leaq reg_fw_617374722d62797465(%rip), %rdi
  call fr_reg_get
  movabsq $114, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_530
  movabsq $13, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_617374722d62797465,16,16
  leaq reg_fw_617374722d62797465(%rip), %rdi
  call fr_reg_set
.Lfranc_530:
  leaq reg_fw_617374722d62797465(%rip), %rdi
  call fr_reg_get
  movabsq $116, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_531
  movabsq $9, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_617374722d62797465,16,16
  leaq reg_fw_617374722d62797465(%rip), %rdi
  call fr_reg_set
.Lfranc_531:
  leaq reg_fw_617374722d62797465(%rip), %rdi
  call fr_reg_get
  movabsq $48, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_532
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_617374722d62797465,16,16
  leaq reg_fw_617374722d62797465(%rip), %rdi
  call fr_reg_set
.Lfranc_532:
.Lfranc_527:
  leaq reg_fw_617374722d62797465(%rip), %rdi
  call fr_reg_get
  call fw_616f742d646174612d62797465
  leaq reg_fw_617374722d706f73(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_617374722d706f73,16,16
  leaq reg_fw_617374722d706f73(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_519
  ret
fw_616f742d7265672d656e64:
.comm reg_fw_6172652d706f73,16,16
  leaq reg_fw_6172652d706f73(%rip), %rdi
  call fr_reg_set
.Lfranc_533:
  call fr_s2_line_buffer
  leaq reg_fw_6172652d706f73(%rip), %rdi
  call fr_reg_get
  call fr_add
  call fr_bfetch
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_534
  leaq reg_fw_6172652d706f73(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
  ret
.Lfranc_534:
  leaq reg_fw_6172652d706f73(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_6172652d706f73,16,16
  leaq reg_fw_6172652d706f73(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_533
  ret
fw_616f742d7265672d66696e64:
.comm reg_fw_6172662d6e616d65,16,16
  leaq reg_fw_6172662d6e616d65(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6172662d706f73,16,16
  leaq reg_fw_6172662d706f73(%rip), %rdi
  call fr_reg_set
.Lfranc_535:
  leaq reg_fw_6172662d706f73(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_616f742d7265672d75736564(%rip), %rdi
  call fr_reg_get
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_536
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_536:
  call fr_s2_line_buffer
  leaq reg_fw_6172662d706f73(%rip), %rdi
  call fr_reg_get
  call fr_add
  leaq reg_fw_6172662d6e616d65(%rip), %rdi
  call fr_reg_get
  call fw_73322d6571
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_537
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_537:
  leaq reg_fw_6172662d706f73(%rip), %rdi
  call fr_reg_get
  call fw_616f742d7265672d656e64
.comm reg_fw_6172662d706f73,16,16
  leaq reg_fw_6172662d706f73(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_535
  ret
fw_616f742d7265672d72656d656d626572:
.comm reg_fw_6172722d6e616d65,16,16
  leaq reg_fw_6172722d6e616d65(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_6172722d6e616d65(%rip), %rdi
  call fr_reg_get
  call fw_616f742d7265672d66696e64
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_538
  ret
.Lfranc_538:
  leaq reg_fw_616f742d7265672d75736564(%rip), %rdi
  call fr_reg_get
.comm reg_fw_6172722d706f73,16,16
  leaq reg_fw_6172722d706f73(%rip), %rdi
  call fr_reg_set
.Lfranc_539:
  leaq reg_fw_6172722d6e616d65(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
.comm reg_fw_6172722d62797465,16,16
  leaq reg_fw_6172722d62797465(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_6172722d706f73(%rip), %rdi
  call fr_reg_get
  movabsq $16383, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_540
  ret
.Lfranc_540:
  call fr_s2_line_buffer
  leaq reg_fw_6172722d706f73(%rip), %rdi
  call fr_reg_get
  call fr_add
  leaq reg_fw_6172722d62797465(%rip), %rdi
  call fr_reg_get
  call fr_bstore
  leaq reg_fw_6172722d706f73(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_6172722d706f73,16,16
  leaq reg_fw_6172722d706f73(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_6172722d6e616d65(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_6172722d6e616d65,16,16
  leaq reg_fw_6172722d6e616d65(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_6172722d62797465(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_541
  leaq reg_fw_6172722d706f73(%rip), %rdi
  call fr_reg_get
.comm reg_fw_616f742d7265672d75736564,16,16
  leaq reg_fw_616f742d7265672d75736564(%rip), %rdi
  call fr_reg_set
  ret
.Lfranc_541:
  jmp .Lfranc_539
  ret
fw_616f742d7265672d7363616e:
.comm reg_fw_6172732d736f75726365,16,16
  leaq reg_fw_6172732d736f75726365(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_616f742d7265672d75736564,16,16
  leaq reg_fw_616f742d7265672d75736564(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_6172732d736f75726365(%rip), %rdi
  call fr_reg_get
.comm reg_fw_733270,16,16
  leaq reg_fw_733270(%rip), %rdi
  call fr_reg_set
.Lfranc_542:
  call fw_616f742d6e657874
.comm reg_fw_6172732d746f6b656e,16,16
  leaq reg_fw_6172732d746f6b656e(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_6172732d746f6b656e(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_543
  ret
.Lfranc_543:
  leaq reg_fw_6172732d746f6b656e(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
  movabsq $58, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_544
  leaq reg_fw_6172732d746f6b656e(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
  call fw_616f742d7265672d72656d656d626572
.Lfranc_544:
  jmp .Lfranc_542
  ret
fw_616f742d7265672d6c6162656c:
.comm reg_fw_61726c2d6e616d65,16,16
  leaq reg_fw_61726c2d6e616d65(%rip), %rdi
  call fr_reg_set
.section .rodata
.Laot_string_545:
  .byte 114
  .byte 101
  .byte 103
  .byte 95
  .byte 0
.section .text
  leaq .Laot_string_545(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  leaq reg_fw_61726c2d6e616d65(%rip), %rdi
  call fr_reg_get
  call fw_616f742d6e616d65
  ret
fw_616f742d7265672d61646472:
.comm reg_fw_6172612d6e616d65,16,16
  leaq reg_fw_6172612d6e616d65(%rip), %rdi
  call fr_reg_set
.section .rodata
.Laot_string_546:
  .byte 32
  .byte 32
  .byte 108
  .byte 101
  .byte 97
  .byte 113
  .byte 32
  .byte 0
.section .text
  leaq .Laot_string_546(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  leaq reg_fw_6172612d6e616d65(%rip), %rdi
  call fr_reg_get
  call fw_616f742d7265672d6c6162656c
.section .rodata
.Laot_string_547:
  .byte 40
  .byte 37
  .byte 114
  .byte 105
  .byte 112
  .byte 41
  .byte 44
  .byte 32
  .byte 37
  .byte 114
  .byte 100
  .byte 105
  .byte 0
.section .text
  leaq .Laot_string_547(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  ret
fw_616f742d7265672d736574:
.comm reg_fw_6172732d6e616d65,16,16
  leaq reg_fw_6172732d6e616d65(%rip), %rdi
  call fr_reg_set
.section .rodata
.Laot_string_548:
  .byte 46
  .byte 99
  .byte 111
  .byte 109
  .byte 109
  .byte 32
  .byte 0
.section .text
  leaq .Laot_string_548(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  leaq reg_fw_6172732d6e616d65(%rip), %rdi
  call fr_reg_get
  call fw_616f742d7265672d6c6162656c
.section .rodata
.Laot_string_549:
  .byte 44
  .byte 49
  .byte 54
  .byte 44
  .byte 49
  .byte 54
  .byte 0
.section .text
  leaq .Laot_string_549(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  leaq reg_fw_6172732d6e616d65(%rip), %rdi
  call fr_reg_get
  call fw_616f742d7265672d61646472
.section .rodata
.Laot_string_550:
  .byte 32
  .byte 32
  .byte 99
  .byte 97
  .byte 108
  .byte 108
  .byte 32
  .byte 102
  .byte 114
  .byte 95
  .byte 114
  .byte 101
  .byte 103
  .byte 95
  .byte 115
  .byte 101
  .byte 116
  .byte 0
.section .text
  leaq .Laot_string_550(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
fw_616f742d7265672d676574:
.comm reg_fw_6172672d6e616d65,16,16
  leaq reg_fw_6172672d6e616d65(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_6172672d6e616d65(%rip), %rdi
  call fr_reg_get
  call fw_616f742d7265672d66696e64
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_551
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_551:
  leaq reg_fw_6172672d6e616d65(%rip), %rdi
  call fr_reg_get
  call fw_616f742d7265672d61646472
.section .rodata
.Laot_string_552:
  .byte 32
  .byte 32
  .byte 99
  .byte 97
  .byte 108
  .byte 108
  .byte 32
  .byte 102
  .byte 114
  .byte 95
  .byte 114
  .byte 101
  .byte 103
  .byte 95
  .byte 103
  .byte 101
  .byte 116
  .byte 0
.section .text
  leaq .Laot_string_552(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
fw_616f742d737472696e672d7265672d64656d6f:
.section .rodata
.Laot_string_553:
  .byte 100
  .byte 101
  .byte 102
  .byte 32
  .byte 109
  .byte 97
  .byte 105
  .byte 110
  .byte 32
  .byte 49
  .byte 48
  .byte 32
  .byte 58
  .byte 115
  .byte 97
  .byte 118
  .byte 101
  .byte 100
  .byte 32
  .byte 34
  .byte 70
  .byte 114
  .byte 97
  .byte 110
  .byte 99
  .byte 32
  .byte 65
  .byte 79
  .byte 84
  .byte 34
  .byte 32
  .byte 116
  .byte 121
  .byte 112
  .byte 101
  .byte 32
  .byte 49
  .byte 48
  .byte 32
  .byte 101
  .byte 109
  .byte 105
  .byte 116
  .byte 32
  .byte 115
  .byte 97
  .byte 118
  .byte 101
  .byte 100
  .byte 32
  .byte 46
  .byte 32
  .byte 59
  .byte 0
.section .text
  leaq .Laot_string_553(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_616f742d70726f6772616d
  call fr_drop
.section .rodata
.Laot_string_554:
  .byte 70
  .byte 82
  .byte 65
  .byte 78
  .byte 67
  .byte 45
  .byte 83
  .byte 84
  .byte 82
  .byte 73
  .byte 78
  .byte 71
  .byte 45
  .byte 69
  .byte 78
  .byte 68
  .byte 0
.section .text
  leaq .Laot_string_554(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  ret
fw_616f742d736b69702d636f6d6d656e74:
.Lfranc_555:
  leaq reg_fw_733270(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
.comm reg_fw_6173632d63686172,16,16
  leaq reg_fw_6173632d63686172(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_6173632d63686172(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_556
  ret
.Lfranc_556:
  leaq reg_fw_733270(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_733270,16,16
  leaq reg_fw_733270(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_6173632d63686172(%rip), %rdi
  call fr_reg_get
  movabsq $10, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_557
  ret
.Lfranc_557:
  jmp .Lfranc_555
  ret
fw_616f742d6e657874:
.Lfranc_558:
  leaq reg_fw_733270(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
.comm reg_fw_61782d6368,16,16
  leaq reg_fw_61782d6368(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_61782d6368(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_559
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_559:
  leaq reg_fw_61782d6368(%rip), %rdi
  call fr_reg_get
  movabsq $33, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_560
  leaq reg_fw_733270(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_733270,16,16
  leaq reg_fw_733270(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_561
.Lfranc_560:
  leaq reg_fw_61782d6368(%rip), %rdi
  call fr_reg_get
  movabsq $92, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_562
  call fw_616f742d736b69702d636f6d6d656e74
  jmp .Lfranc_563
.Lfranc_562:
  call fr_s2_token_buffer
.comm reg_fw_61782d647374,16,16
  leaq reg_fw_61782d647374(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_61782d71756f7465,16,16
  leaq reg_fw_61782d71756f7465(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_61782d657363617065,16,16
  leaq reg_fw_61782d657363617065(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_61782d636f756e74,16,16
  leaq reg_fw_61782d636f756e74(%rip), %rdi
  call fr_reg_set
.Lfranc_564:
  leaq reg_fw_733270(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
.comm reg_fw_61782d6368,16,16
  leaq reg_fw_61782d6368(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_61782d6368(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_565
  leaq reg_fw_61782d647374(%rip), %rdi
  call fr_reg_get
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_bstore
  call fr_s2_token_buffer
  ret
.Lfranc_565:
  leaq reg_fw_61782d71756f7465(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_566
  leaq reg_fw_61782d6368(%rip), %rdi
  call fr_reg_get
  movabsq $33, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_567
  leaq reg_fw_61782d647374(%rip), %rdi
  call fr_reg_get
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_bstore
  call fr_s2_token_buffer
  ret
.Lfranc_567:
  leaq reg_fw_61782d6368(%rip), %rdi
  call fr_reg_get
  movabsq $92, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_568
  leaq reg_fw_61782d647374(%rip), %rdi
  call fr_reg_get
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_bstore
  call fr_s2_token_buffer
  ret
.Lfranc_568:
.Lfranc_566:
  leaq reg_fw_61782d636f756e74(%rip), %rdi
  call fr_reg_get
  movabsq $1000, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_569
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_569:
  leaq reg_fw_61782d647374(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_61782d6368(%rip), %rdi
  call fr_reg_get
  call fr_bstore
  leaq reg_fw_61782d6368(%rip), %rdi
  call fr_reg_get
  movabsq $34, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_570
  leaq reg_fw_61782d657363617065(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_571
  leaq reg_fw_61782d71756f7465(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_572
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_61782d71756f7465,16,16
  leaq reg_fw_61782d71756f7465(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_573
.Lfranc_572:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_61782d71756f7465,16,16
  leaq reg_fw_61782d71756f7465(%rip), %rdi
  call fr_reg_set
.Lfranc_573:
.Lfranc_571:
.Lfranc_570:
  leaq reg_fw_61782d6368(%rip), %rdi
  call fr_reg_get
  movabsq $92, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_574
  leaq reg_fw_61782d71756f7465(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_575
  leaq reg_fw_61782d657363617065(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_576
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_61782d657363617065,16,16
  leaq reg_fw_61782d657363617065(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_577
.Lfranc_576:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_61782d657363617065,16,16
  leaq reg_fw_61782d657363617065(%rip), %rdi
  call fr_reg_set
.Lfranc_577:
.Lfranc_575:
  jmp .Lfranc_578
.Lfranc_574:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_61782d657363617065,16,16
  leaq reg_fw_61782d657363617065(%rip), %rdi
  call fr_reg_set
.Lfranc_578:
  leaq reg_fw_61782d647374(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_61782d647374,16,16
  leaq reg_fw_61782d647374(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_733270(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_733270,16,16
  leaq reg_fw_733270(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_61782d636f756e74(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_61782d636f756e74,16,16
  leaq reg_fw_61782d636f756e74(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_564
.Lfranc_563:
.Lfranc_561:
  jmp .Lfranc_558
  ret
fw_616f742d6b65726e656c2d66726f6d2d736f75726365:
.comm reg_fw_616b2d736f75726365,16,16
  leaq reg_fw_616b2d736f75726365(%rip), %rdi
  call fr_reg_set
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_616f742d6b65726e656c2d6d6f6465,16,16
  leaq reg_fw_616f742d6b65726e656c2d6d6f6465(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_616b2d736f75726365(%rip), %rdi
  call fr_reg_get
  call fw_616f742d70726f6772616d
.comm reg_fw_616b2d6f6b,16,16
  leaq reg_fw_616b2d6f6b(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_616f742d6b65726e656c2d6d6f6465,16,16
  leaq reg_fw_616f742d6b65726e656c2d6d6f6465(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_616b2d6f6b(%rip), %rdi
  call fr_reg_get
  ret
fw_616f742d656d69742d6e616d652d6279746573:
.comm reg_fw_616e622d6e616d65,16,16
  leaq reg_fw_616e622d6e616d65(%rip), %rdi
  call fr_reg_set
.Lfranc_579:
  leaq reg_fw_616e622d6e616d65(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
.comm reg_fw_616e622d63686172,16,16
  leaq reg_fw_616e622d63686172(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_616e622d63686172(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_580
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_616f742d646174612d62797465
  ret
.Lfranc_580:
  leaq reg_fw_616e622d63686172(%rip), %rdi
  call fr_reg_get
  call fw_616f742d646174612d62797465
  leaq reg_fw_616e622d6e616d65(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_616e622d6e616d65,16,16
  leaq reg_fw_616e622d6e616d65(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_579
  ret
fw_616f742d656d69742d6669656c642d6279746573:
.comm reg_fw_6166622d6e616d65,16,16
  leaq reg_fw_6166622d6e616d65(%rip), %rdi
  call fr_reg_set
.Lfranc_581:
  leaq reg_fw_6166622d6e616d65(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
.comm reg_fw_6166622d63686172,16,16
  leaq reg_fw_6166622d63686172(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_6166622d63686172(%rip), %rdi
  call fr_reg_get
  movabsq $124, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_582
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_616f742d646174612d62797465
  ret
.Lfranc_582:
  leaq reg_fw_6166622d63686172(%rip), %rdi
  call fr_reg_get
  call fw_616f742d646174612d62797465
  leaq reg_fw_6166622d6e616d65(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_6166622d6e616d65,16,16
  leaq reg_fw_6166622d6e616d65(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_581
  ret
fw_616f742d656d69742d6669656c64:
.comm reg_fw_6165662d70,16,16
  leaq reg_fw_6165662d70(%rip), %rdi
  call fr_reg_set
.Lfranc_583:
  leaq reg_fw_6165662d70(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
.comm reg_fw_6165662d6368,16,16
  leaq reg_fw_6165662d6368(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_6165662d6368(%rip), %rdi
  call fr_reg_get
  movabsq $124, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_584
  ret
.Lfranc_584:
  leaq reg_fw_6165662d6368(%rip), %rdi
  call fr_reg_get
  call fr_emit
  leaq reg_fw_6165662d70(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_6165662d70,16,16
  leaq reg_fw_6165662d70(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_583
  ret
fw_616f742d6d6574612d6e616d652d6c6162656c:
.section .rodata
.Laot_string_585:
  .byte 46
  .byte 76
  .byte 97
  .byte 111
  .byte 116
  .byte 95
  .byte 119
  .byte 111
  .byte 114
  .byte 100
  .byte 95
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 95
  .byte 0
.section .text
  leaq .Laot_string_585(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  leaq reg_fw_616f742d6d6574612d636f756e74(%rip), %rdi
  call fr_reg_get
  call fw_616f742d646563
  ret
fw_616f742d6d6574612d656e7472792d6c6162656c:
.section .rodata
.Laot_string_586:
  .byte 46
  .byte 76
  .byte 97
  .byte 111
  .byte 116
  .byte 95
  .byte 119
  .byte 111
  .byte 114
  .byte 100
  .byte 95
  .byte 101
  .byte 110
  .byte 116
  .byte 114
  .byte 121
  .byte 95
  .byte 0
.section .text
  leaq .Laot_string_586(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  leaq reg_fw_616f742d6d6574612d636f756e74(%rip), %rdi
  call fr_reg_get
  call fw_616f742d646563
  ret
fw_616f742d6d6574612d726566:
.comm reg_fw_616d722d6b696e64,16,16
  leaq reg_fw_616d722d6b696e64(%rip), %rdi
  call fr_reg_set
.comm reg_fw_616d722d746172676574,16,16
  leaq reg_fw_616d722d746172676574(%rip), %rdi
  call fr_reg_set
.comm reg_fw_616d722d6e616d65,16,16
  leaq reg_fw_616d722d6e616d65(%rip), %rdi
  call fr_reg_set
.section .rodata
.Laot_string_587:
  .byte 46
  .byte 115
  .byte 101
  .byte 99
  .byte 116
  .byte 105
  .byte 111
  .byte 110
  .byte 32
  .byte 46
  .byte 114
  .byte 111
  .byte 100
  .byte 97
  .byte 116
  .byte 97
  .byte 0
.section .text
  leaq .Laot_string_587(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  call fw_616f742d6d6574612d6e616d652d6c6162656c
.section .rodata
.Laot_string_588:
  .byte 58
  .byte 0
.section .text
  leaq .Laot_string_588(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  leaq reg_fw_616d722d6b696e64(%rip), %rdi
  call fr_reg_get
  movabsq $3, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_589
  movabsq $58, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_616f742d646174612d62797465
.Lfranc_589:
  leaq reg_fw_616d722d6b696e64(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_590
  leaq reg_fw_616d722d6e616d65(%rip), %rdi
  call fr_reg_get
  call fw_616f742d656d69742d6669656c642d6279746573
  jmp .Lfranc_591
.Lfranc_590:
  leaq reg_fw_616d722d6e616d65(%rip), %rdi
  call fr_reg_get
  call fw_616f742d656d69742d6e616d652d6279746573
.Lfranc_591:
.section .rodata
.Laot_string_592:
  .byte 46
  .byte 115
  .byte 101
  .byte 99
  .byte 116
  .byte 105
  .byte 111
  .byte 110
  .byte 32
  .byte 46
  .byte 100
  .byte 97
  .byte 116
  .byte 97
  .byte 0
.section .text
  leaq .Laot_string_592(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  call fw_616f742d6d6574612d656e7472792d6c6162656c
.section .rodata
.Laot_string_593:
  .byte 58
  .byte 0
.section .text
  leaq .Laot_string_593(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
.section .rodata
.Laot_string_594:
  .byte 32
  .byte 32
  .byte 46
  .byte 113
  .byte 117
  .byte 97
  .byte 100
  .byte 32
  .byte 0
.section .text
  leaq .Laot_string_594(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  leaq reg_fw_616f742d6d6574612d636f756e74(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_595
.section .rodata
.Laot_string_596:
  .byte 48
  .byte 0
.section .text
  leaq .Laot_string_596(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  jmp .Lfranc_597
.Lfranc_595:
  leaq reg_fw_616f742d6d6574612d636f756e74(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
.comm reg_fw_616f742d6d6574612d636f756e74,16,16
  leaq reg_fw_616f742d6d6574612d636f756e74(%rip), %rdi
  call fr_reg_set
  call fw_616f742d6d6574612d656e7472792d6c6162656c
  leaq reg_fw_616f742d6d6574612d636f756e74(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_616f742d6d6574612d636f756e74,16,16
  leaq reg_fw_616f742d6d6574612d636f756e74(%rip), %rdi
  call fr_reg_set
.Lfranc_597:
  call fr_cr
.section .rodata
.Laot_string_598:
  .byte 32
  .byte 32
  .byte 46
  .byte 113
  .byte 117
  .byte 97
  .byte 100
  .byte 32
  .byte 0
.section .text
  leaq .Laot_string_598(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fw_616f742d6d6574612d6e616d652d6c6162656c
  call fr_cr
.section .rodata
.Laot_string_599:
  .byte 32
  .byte 32
  .byte 46
  .byte 113
  .byte 117
  .byte 97
  .byte 100
  .byte 32
  .byte 0
.section .text
  leaq .Laot_string_599(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  leaq reg_fw_616d722d6b696e64(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_600
  leaq reg_fw_616d722d6e616d65(%rip), %rdi
  call fr_reg_get
  call fw_616f742d6e616d65
  jmp .Lfranc_601
.Lfranc_600:
  leaq reg_fw_616d722d6b696e64(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_602
  leaq reg_fw_616d722d746172676574(%rip), %rdi
  call fr_reg_get
  call fw_616f742d656d69742d6669656c64
  jmp .Lfranc_603
.Lfranc_602:
  leaq reg_fw_616d722d6b696e64(%rip), %rdi
  call fr_reg_get
  movabsq $2, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_604
.section .rodata
.Laot_string_605:
  .byte 97
  .byte 111
  .byte 116
  .byte 95
  .byte 103
  .byte 101
  .byte 116
  .byte 95
  .byte 0
.section .text
  leaq .Laot_string_605(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  leaq reg_fw_616d722d6e616d65(%rip), %rdi
  call fr_reg_get
  call fw_616f742d6e616d65
  jmp .Lfranc_606
.Lfranc_604:
.section .rodata
.Laot_string_607:
  .byte 97
  .byte 111
  .byte 116
  .byte 95
  .byte 115
  .byte 101
  .byte 116
  .byte 95
  .byte 0
.section .text
  leaq .Laot_string_607(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  leaq reg_fw_616d722d6e616d65(%rip), %rdi
  call fr_reg_get
  call fw_616f742d6e616d65
.Lfranc_606:
.Lfranc_603:
.Lfranc_601:
  call fr_cr
  leaq reg_fw_616f742d6d6574612d636f756e74(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_616f742d6d6574612d636f756e74,16,16
  leaq reg_fw_616f742d6d6574612d636f756e74(%rip), %rdi
  call fr_reg_set
  ret
fw_616f742d6d6574612d7461626c65:
.comm reg_fw_616d742d70,16,16
  leaq reg_fw_616d742d70(%rip), %rdi
  call fr_reg_set
.Lfranc_608:
  leaq reg_fw_616d742d70(%rip), %rdi
  call fr_reg_get
  call fr_bfetch
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_609
  ret
.Lfranc_609:
  leaq reg_fw_616d742d70(%rip), %rdi
  call fr_reg_get
  call fw_616f742d6669656c642d656e64
.comm reg_fw_616d742d746172676574,16,16
  leaq reg_fw_616d742d746172676574(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_616d742d70(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_616d742d746172676574(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_616f742d6d6574612d726566
  leaq reg_fw_616d742d746172676574(%rip), %rdi
  call fr_reg_get
  call fw_616f742d6669656c642d656e64
.comm reg_fw_616d742d70,16,16
  leaq reg_fw_616d742d70(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_608
  ret
fw_616f742d6d6574612d646566696e6974696f6e73:
.comm reg_fw_616d642d736f75726365,16,16
  leaq reg_fw_616d642d736f75726365(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_616d642d736f75726365(%rip), %rdi
  call fr_reg_get
.comm reg_fw_733270,16,16
  leaq reg_fw_733270(%rip), %rdi
  call fr_reg_set
.Lfranc_610:
  call fw_616f742d6e657874
.comm reg_fw_616d642d746f6b656e,16,16
  leaq reg_fw_616d642d746f6b656e(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_616d642d746f6b656e(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_611
  ret
.Lfranc_611:
  leaq reg_fw_616d642d746f6b656e(%rip), %rdi
  call fr_reg_get
.section .rodata
.Laot_string_612:
  .byte 100
  .byte 101
  .byte 102
  .byte 0
.section .text
  leaq .Laot_string_612(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d6571
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_613
  call fw_616f742d6e657874
.comm reg_fw_616d642d646566,16,16
  leaq reg_fw_616d642d646566(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_616d642d646566(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_614
  ret
.Lfranc_614:
  leaq reg_fw_616d642d646566(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_616d642d646566(%rip), %rdi
  call fr_reg_get
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_616f742d6d6574612d726566
.Lfranc_613:
  jmp .Lfranc_610
  ret
fw_616f742d6d6574612d7265672d7374756273:
.comm reg_fw_616d732d726567,16,16
  leaq reg_fw_616d732d726567(%rip), %rdi
  call fr_reg_set
.section .rodata
.Laot_string_615:
  .byte 46
  .byte 115
  .byte 101
  .byte 99
  .byte 116
  .byte 105
  .byte 111
  .byte 110
  .byte 32
  .byte 46
  .byte 116
  .byte 101
  .byte 120
  .byte 116
  .byte 0
.section .text
  leaq .Laot_string_615(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
.section .rodata
.Laot_string_616:
  .byte 97
  .byte 111
  .byte 116
  .byte 95
  .byte 103
  .byte 101
  .byte 116
  .byte 95
  .byte 0
.section .text
  leaq .Laot_string_616(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  leaq reg_fw_616d732d726567(%rip), %rdi
  call fr_reg_get
  call fw_616f742d6e616d65
.section .rodata
.Laot_string_617:
  .byte 58
  .byte 0
.section .text
  leaq .Laot_string_617(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  leaq reg_fw_616d732d726567(%rip), %rdi
  call fr_reg_get
  call fw_616f742d7265672d61646472
.section .rodata
.Laot_string_618:
  .byte 32
  .byte 32
  .byte 106
  .byte 109
  .byte 112
  .byte 32
  .byte 102
  .byte 114
  .byte 95
  .byte 114
  .byte 101
  .byte 103
  .byte 95
  .byte 103
  .byte 101
  .byte 116
  .byte 0
.section .text
  leaq .Laot_string_618(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
.section .rodata
.Laot_string_619:
  .byte 97
  .byte 111
  .byte 116
  .byte 95
  .byte 115
  .byte 101
  .byte 116
  .byte 95
  .byte 0
.section .text
  leaq .Laot_string_619(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  leaq reg_fw_616d732d726567(%rip), %rdi
  call fr_reg_get
  call fw_616f742d6e616d65
.section .rodata
.Laot_string_620:
  .byte 58
  .byte 0
.section .text
  leaq .Laot_string_620(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  leaq reg_fw_616d732d726567(%rip), %rdi
  call fr_reg_get
  call fw_616f742d7265672d61646472
.section .rodata
.Laot_string_621:
  .byte 32
  .byte 32
  .byte 106
  .byte 109
  .byte 112
  .byte 32
  .byte 102
  .byte 114
  .byte 95
  .byte 114
  .byte 101
  .byte 103
  .byte 95
  .byte 115
  .byte 101
  .byte 116
  .byte 0
.section .text
  leaq .Laot_string_621(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  ret
fw_616f742d6d6574612d726567697374657273:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_616d672d706f73,16,16
  leaq reg_fw_616d672d706f73(%rip), %rdi
  call fr_reg_set
.Lfranc_622:
  leaq reg_fw_616d672d706f73(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_616f742d7265672d75736564(%rip), %rdi
  call fr_reg_get
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_623
  ret
.Lfranc_623:
  call fr_s2_line_buffer
  leaq reg_fw_616d672d706f73(%rip), %rdi
  call fr_reg_get
  call fr_add
.comm reg_fw_616d672d726567,16,16
  leaq reg_fw_616d672d726567(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_616d672d726567(%rip), %rdi
  call fr_reg_get
  call fw_616f742d6d6574612d7265672d7374756273
  leaq reg_fw_616d672d726567(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_616d672d726567(%rip), %rdi
  call fr_reg_get
  movabsq $2, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_616f742d6d6574612d726566
  leaq reg_fw_616d672d726567(%rip), %rdi
  call fr_reg_get
  leaq reg_fw_616d672d726567(%rip), %rdi
  call fr_reg_get
  movabsq $3, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_616f742d6d6574612d726566
  leaq reg_fw_616d672d706f73(%rip), %rdi
  call fr_reg_get
  call fw_616f742d7265672d656e64
.comm reg_fw_616d672d706f73,16,16
  leaq reg_fw_616d672d706f73(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_622
  ret
fw_616f742d656d69742d6b65726e656c2d6d65746164617461:
.comm reg_fw_616b6d2d736f75726365,16,16
  leaq reg_fw_616b6d2d736f75726365(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_616f742d6d6574612d636f756e74,16,16
  leaq reg_fw_616f742d6d6574612d636f756e74(%rip), %rdi
  call fr_reg_set
  call fw_616f742d6f70732d6f6e65
  call fw_616f742d6d6574612d7461626c65
  call fw_616f742d6f70732d74776f
  call fw_616f742d6d6574612d7461626c65
  leaq reg_fw_616b6d2d736f75726365(%rip), %rdi
  call fr_reg_get
  call fw_616f742d6d6574612d646566696e6974696f6e73
  call fw_616f742d6d6574612d726567697374657273
.section .rodata
.Laot_string_624:
  .byte 46
  .byte 115
  .byte 101
  .byte 99
  .byte 116
  .byte 105
  .byte 111
  .byte 110
  .byte 32
  .byte 46
  .byte 100
  .byte 97
  .byte 116
  .byte 97
  .byte 0
.section .text
  leaq .Laot_string_624(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
.section .rodata
.Laot_string_625:
  .byte 46
  .byte 103
  .byte 108
  .byte 111
  .byte 98
  .byte 97
  .byte 108
  .byte 32
  .byte 102
  .byte 114
  .byte 97
  .byte 110
  .byte 99
  .byte 95
  .byte 100
  .byte 105
  .byte 99
  .byte 116
  .byte 95
  .byte 105
  .byte 110
  .byte 105
  .byte 116
  .byte 105
  .byte 97
  .byte 108
  .byte 0
.section .text
  leaq .Laot_string_625(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
.section .rodata
.Laot_string_626:
  .byte 102
  .byte 114
  .byte 97
  .byte 110
  .byte 99
  .byte 95
  .byte 100
  .byte 105
  .byte 99
  .byte 116
  .byte 95
  .byte 105
  .byte 110
  .byte 105
  .byte 116
  .byte 105
  .byte 97
  .byte 108
  .byte 58
  .byte 0
.section .text
  leaq .Laot_string_626(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
.section .rodata
.Laot_string_627:
  .byte 32
  .byte 32
  .byte 46
  .byte 113
  .byte 117
  .byte 97
  .byte 100
  .byte 32
  .byte 0
.section .text
  leaq .Laot_string_627(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  leaq reg_fw_616f742d6d6574612d636f756e74(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_628
.section .rodata
.Laot_string_629:
  .byte 48
  .byte 0
.section .text
  leaq .Laot_string_629(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  jmp .Lfranc_630
.Lfranc_628:
  leaq reg_fw_616f742d6d6574612d636f756e74(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
.comm reg_fw_616f742d6d6574612d636f756e74,16,16
  leaq reg_fw_616f742d6d6574612d636f756e74(%rip), %rdi
  call fr_reg_set
  call fw_616f742d6d6574612d656e7472792d6c6162656c
  leaq reg_fw_616f742d6d6574612d636f756e74(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_616f742d6d6574612d636f756e74,16,16
  leaq reg_fw_616f742d6d6574612d636f756e74(%rip), %rdi
  call fr_reg_set
.Lfranc_630:
  call fr_cr
.section .rodata
.Laot_string_631:
  .byte 46
  .byte 115
  .byte 101
  .byte 99
  .byte 116
  .byte 105
  .byte 111
  .byte 110
  .byte 32
  .byte 46
  .byte 114
  .byte 111
  .byte 100
  .byte 97
  .byte 116
  .byte 97
  .byte 0
.section .text
  leaq .Laot_string_631(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
.section .rodata
.Laot_string_632:
  .byte 46
  .byte 103
  .byte 108
  .byte 111
  .byte 98
  .byte 97
  .byte 108
  .byte 32
  .byte 102
  .byte 114
  .byte 97
  .byte 110
  .byte 99
  .byte 95
  .byte 115
  .byte 116
  .byte 97
  .byte 103
  .byte 101
  .byte 50
  .byte 95
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 0
.section .text
  leaq .Laot_string_632(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
.section .rodata
.Laot_string_633:
  .byte 102
  .byte 114
  .byte 97
  .byte 110
  .byte 99
  .byte 95
  .byte 115
  .byte 116
  .byte 97
  .byte 103
  .byte 101
  .byte 50
  .byte 95
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 58
  .byte 0
.section .text
  leaq .Laot_string_633(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
.section .rodata
.Laot_string_634:
  .byte 32
  .byte 32
  .byte 46
  .byte 105
  .byte 110
  .byte 99
  .byte 98
  .byte 105
  .byte 110
  .byte 32
  .byte 34
  .byte 115
  .byte 116
  .byte 97
  .byte 103
  .byte 101
  .byte 50
  .byte 47
  .byte 99
  .byte 111
  .byte 109
  .byte 112
  .byte 105
  .byte 108
  .byte 101
  .byte 114
  .byte 46
  .byte 102
  .byte 114
  .byte 97
  .byte 99
  .byte 34
  .byte 0
.section .text
  leaq .Laot_string_634(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
.section .rodata
.Laot_string_635:
  .byte 32
  .byte 32
  .byte 46
  .byte 98
  .byte 121
  .byte 116
  .byte 101
  .byte 32
  .byte 48
  .byte 0
.section .text
  leaq .Laot_string_635(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  ret
fw_62756e646c652d736f75726365:
  movabsq $512, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_6174612d726561642d736563746f72
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_636
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_636:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sector_bfetch
  movabsq $70, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_637
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_637:
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sector_bfetch
  movabsq $82, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_638
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_638:
  movabsq $2, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sector_bfetch
  movabsq $65, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_639
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_639:
  movabsq $3, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sector_bfetch
  movabsq $78, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_640
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_640:
  movabsq $4, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sector_bfetch
  movabsq $67, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_641
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_641:
  movabsq $5, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sector_bfetch
  movabsq $83, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_642
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_642:
  movabsq $6, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sector_bfetch
  movabsq $82, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_643
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_643:
  movabsq $7, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sector_bfetch
  movabsq $67, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_644
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_644:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_62732d636f756e74,16,16
  leaq reg_fw_62732d636f756e74(%rip), %rdi
  call fr_reg_set
  movabsq $513, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_62732d6c6261,16,16
  leaq reg_fw_62732d6c6261(%rip), %rdi
  call fr_reg_set
.Lfranc_645:
  leaq reg_fw_62732d6c6261(%rip), %rdi
  call fr_reg_get
  movabsq $769, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_646
  leaq reg_fw_62732d6c6261(%rip), %rdi
  call fr_reg_get
  call fw_6174612d726561642d736563746f72
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_647
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_647:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_62732d696e646578,16,16
  leaq reg_fw_62732d696e646578(%rip), %rdi
  call fr_reg_set
.Lfranc_648:
  leaq reg_fw_62732d696e646578(%rip), %rdi
  call fr_reg_get
  movabsq $512, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_649
  leaq reg_fw_62732d636f756e74(%rip), %rdi
  call fr_reg_get
  movabsq $131071, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_650
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_650:
  leaq reg_fw_62732d696e646578(%rip), %rdi
  call fr_reg_get
  call fr_sector_bfetch
.comm reg_fw_62732d62797465,16,16
  leaq reg_fw_62732d62797465(%rip), %rdi
  call fr_reg_set
  call fr_aot_bundle_area
  leaq reg_fw_62732d636f756e74(%rip), %rdi
  call fr_reg_get
  call fr_add
  leaq reg_fw_62732d62797465(%rip), %rdi
  call fr_reg_get
  call fr_bstore
  leaq reg_fw_62732d62797465(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_651
  call fr_aot_bundle_area
  ret
.Lfranc_651:
  leaq reg_fw_62732d636f756e74(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_62732d636f756e74,16,16
  leaq reg_fw_62732d636f756e74(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_62732d696e646578(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_62732d696e646578,16,16
  leaq reg_fw_62732d696e646578(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_648
.Lfranc_649:
  leaq reg_fw_62732d6c6261(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_62732d6c6261,16,16
  leaq reg_fw_62732d6c6261(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_645
.Lfranc_646:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
fw_62756e646c652d64656d6f:
  call fw_62756e646c652d736f75726365
.comm reg_fw_62642d736f75726365,16,16
  leaq reg_fw_62642d736f75726365(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_62642d736f75726365(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_652
.section .rodata
.Laot_string_653:
  .byte 70
  .byte 82
  .byte 65
  .byte 78
  .byte 67
  .byte 45
  .byte 83
  .byte 79
  .byte 85
  .byte 82
  .byte 67
  .byte 69
  .byte 45
  .byte 69
  .byte 82
  .byte 82
  .byte 79
  .byte 82
  .byte 0
.section .text
  leaq .Laot_string_653(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  ret
.Lfranc_652:
  leaq reg_fw_62642d736f75726365(%rip), %rdi
  call fr_reg_get
  call fw_616f742d70726f6772616d
  call fr_drop
.section .rodata
.Laot_string_654:
  .byte 70
  .byte 82
  .byte 65
  .byte 78
  .byte 67
  .byte 45
  .byte 83
  .byte 79
  .byte 85
  .byte 82
  .byte 67
  .byte 69
  .byte 45
  .byte 69
  .byte 78
  .byte 68
  .byte 0
.section .text
  leaq .Laot_string_654(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  ret
fw_62756e646c652d6b65726e656c:
  call fw_62756e646c652d736f75726365
.comm reg_fw_626b2d736f75726365,16,16
  leaq reg_fw_626b2d736f75726365(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_626b2d736f75726365(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_655
.section .rodata
.Laot_string_656:
  .byte 70
  .byte 82
  .byte 65
  .byte 78
  .byte 67
  .byte 45
  .byte 75
  .byte 69
  .byte 82
  .byte 78
  .byte 69
  .byte 76
  .byte 45
  .byte 83
  .byte 79
  .byte 85
  .byte 82
  .byte 67
  .byte 69
  .byte 45
  .byte 69
  .byte 82
  .byte 82
  .byte 79
  .byte 82
  .byte 0
.section .text
  leaq .Laot_string_656(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  ret
.Lfranc_655:
  leaq reg_fw_626b2d736f75726365(%rip), %rdi
  call fr_reg_get
  call fw_616f742d6b65726e656c2d66726f6d2d736f75726365
  call fr_drop
.section .rodata
.Laot_string_657:
  .byte 70
  .byte 82
  .byte 65
  .byte 78
  .byte 67
  .byte 45
  .byte 75
  .byte 69
  .byte 82
  .byte 78
  .byte 69
  .byte 76
  .byte 45
  .byte 69
  .byte 78
  .byte 68
  .byte 0
.section .text
  leaq .Laot_string_657(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  ret
fw_62756e646c652d6170702d736f75726365:
  movabsq $1024, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_6174612d726561642d736563746f72
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_658
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_658:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sector_bfetch
  movabsq $70, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_659
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_659:
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sector_bfetch
  movabsq $82, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_660
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_660:
  movabsq $2, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sector_bfetch
  movabsq $65, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_661
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_661:
  movabsq $3, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sector_bfetch
  movabsq $78, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_662
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_662:
  movabsq $4, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sector_bfetch
  movabsq $67, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_663
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_663:
  movabsq $5, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sector_bfetch
  movabsq $83, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_664
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_664:
  movabsq $6, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sector_bfetch
  movabsq $82, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_665
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_665:
  movabsq $7, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sector_bfetch
  movabsq $67, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jz .Lfranc_666
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_666:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_62732d636f756e74,16,16
  leaq reg_fw_62732d636f756e74(%rip), %rdi
  call fr_reg_set
  movabsq $1025, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_62732d6c6261,16,16
  leaq reg_fw_62732d6c6261(%rip), %rdi
  call fr_reg_set
.Lfranc_667:
  leaq reg_fw_62732d6c6261(%rip), %rdi
  call fr_reg_get
  movabsq $1281, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_668
  leaq reg_fw_62732d6c6261(%rip), %rdi
  call fr_reg_get
  call fw_6174612d726561642d736563746f72
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_669
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_669:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_62732d696e646578,16,16
  leaq reg_fw_62732d696e646578(%rip), %rdi
  call fr_reg_set
.Lfranc_670:
  leaq reg_fw_62732d696e646578(%rip), %rdi
  call fr_reg_get
  movabsq $512, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_671
  leaq reg_fw_62732d636f756e74(%rip), %rdi
  call fr_reg_get
  movabsq $131071, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_672
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
.Lfranc_672:
  leaq reg_fw_62732d696e646578(%rip), %rdi
  call fr_reg_get
  call fr_sector_bfetch
.comm reg_fw_62732d62797465,16,16
  leaq reg_fw_62732d62797465(%rip), %rdi
  call fr_reg_set
  call fr_aot_bundle_area
  leaq reg_fw_62732d636f756e74(%rip), %rdi
  call fr_reg_get
  call fr_add
  leaq reg_fw_62732d62797465(%rip), %rdi
  call fr_reg_get
  call fr_bstore
  leaq reg_fw_62732d62797465(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_673
  call fr_aot_bundle_area
  ret
.Lfranc_673:
  leaq reg_fw_62732d636f756e74(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_62732d636f756e74,16,16
  leaq reg_fw_62732d636f756e74(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_62732d696e646578(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_62732d696e646578,16,16
  leaq reg_fw_62732d696e646578(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_670
.Lfranc_671:
  leaq reg_fw_62732d6c6261(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_62732d6c6261,16,16
  leaq reg_fw_62732d6c6261(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_667
.Lfranc_668:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
fw_617070732d72756e:
.comm reg_fw_61722d6e616d65,16,16
  leaq reg_fw_61722d6e616d65(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_61722d6e616d65(%rip), %rdi
  call fr_reg_get
  call fw_73322d66696e64
.comm reg_fw_61722d636f6465,16,16
  leaq reg_fw_61722d636f6465(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_61722d636f6465(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_674
.section .rodata
.Laot_string_675:
  .byte 65
  .byte 80
  .byte 80
  .byte 32
  .byte 78
  .byte 79
  .byte 84
  .byte 32
  .byte 76
  .byte 79
  .byte 65
  .byte 68
  .byte 69
  .byte 68
  .byte 0
.section .text
  leaq .Laot_string_675(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  ret
.Lfranc_674:
  leaq reg_fw_61722d636f6465(%rip), %rdi
  call fr_reg_get
  call fr_s2_run
  ret
fw_617070732d6c6f6164:
  call fw_62756e646c652d6170702d736f75726365
.comm reg_fw_616c2d736f75726365,16,16
  leaq reg_fw_616c2d736f75726365(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_616c2d736f75726365(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_676
.section .rodata
.Laot_string_677:
  .byte 65
  .byte 80
  .byte 80
  .byte 83
  .byte 32
  .byte 83
  .byte 79
  .byte 85
  .byte 82
  .byte 67
  .byte 69
  .byte 32
  .byte 77
  .byte 73
  .byte 83
  .byte 83
  .byte 73
  .byte 78
  .byte 71
  .byte 0
.section .text
  leaq .Laot_string_677(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  ret
.Lfranc_676:
  leaq reg_fw_616c2d736f75726365(%rip), %rdi
  call fr_reg_get
  call fw_73322d736f75726365
.comm reg_fw_616c2d636f756e74,16,16
  leaq reg_fw_616c2d636f756e74(%rip), %rdi
  call fr_reg_set
.section .rodata
.Laot_string_678:
  .byte 65
  .byte 80
  .byte 80
  .byte 83
  .byte 32
  .byte 76
  .byte 79
  .byte 65
  .byte 68
  .byte 69
  .byte 68
  .byte 32
  .byte 0
.section .text
  leaq .Laot_string_678(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  leaq reg_fw_616c2d636f756e74(%rip), %rdi
  call fr_reg_get
  call fr_dot
.section .rodata
.Laot_string_679:
  .byte 97
  .byte 112
  .byte 112
  .byte 115
  .byte 45
  .byte 105
  .byte 110
  .byte 105
  .byte 116
  .byte 0
.section .text
  leaq .Laot_string_679(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d66696e64
.comm reg_fw_616c2d696e6974,16,16
  leaq reg_fw_616c2d696e6974(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_616c2d696e6974(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_680
.section .rodata
.Laot_string_681:
  .byte 65
  .byte 80
  .byte 80
  .byte 83
  .byte 32
  .byte 73
  .byte 78
  .byte 73
  .byte 84
  .byte 32
  .byte 77
  .byte 73
  .byte 83
  .byte 83
  .byte 73
  .byte 78
  .byte 71
  .byte 0
.section .text
  leaq .Laot_string_681(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  ret
.Lfranc_680:
  leaq reg_fw_616c2d696e6974(%rip), %rdi
  call fr_reg_get
  call fr_s2_run
.section .rodata
.Laot_string_682:
  .byte 65
  .byte 80
  .byte 80
  .byte 83
  .byte 32
  .byte 82
  .byte 69
  .byte 65
  .byte 68
  .byte 89
  .byte 0
.section .text
  leaq .Laot_string_682(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  ret
fw_617070732d6d656e75:
.comm reg_fw_616d2d6b6579,16,16
  leaq reg_fw_616d2d6b6579(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_616d2d6b6579(%rip), %rdi
  call fr_reg_get
  movabsq $49, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_683
.section .rodata
.Laot_string_684:
  .byte 99
  .byte 97
  .byte 108
  .byte 99
  .byte 45
  .byte 109
  .byte 97
  .byte 105
  .byte 110
  .byte 0
.section .text
  leaq .Laot_string_684(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_617070732d72756e
  ret
.Lfranc_683:
  leaq reg_fw_616d2d6b6579(%rip), %rdi
  call fr_reg_get
  movabsq $50, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_685
.section .rodata
.Laot_string_686:
  .byte 97
  .byte 112
  .byte 112
  .byte 45
  .byte 101
  .byte 100
  .byte 105
  .byte 116
  .byte 0
.section .text
  leaq .Laot_string_686(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_617070732d72756e
  ret
.Lfranc_685:
  leaq reg_fw_616d2d6b6579(%rip), %rdi
  call fr_reg_get
  movabsq $51, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_687
.section .rodata
.Laot_string_688:
  .byte 119
  .byte 97
  .byte 108
  .byte 107
  .byte 45
  .byte 109
  .byte 97
  .byte 105
  .byte 110
  .byte 0
.section .text
  leaq .Laot_string_688(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_617070732d72756e
  ret
.Lfranc_687:
  leaq reg_fw_616d2d6b6579(%rip), %rdi
  call fr_reg_get
  movabsq $52, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_689
.section .rodata
.Laot_string_690:
  .byte 97
  .byte 112
  .byte 112
  .byte 45
  .byte 102
  .byte 111
  .byte 110
  .byte 116
  .byte 45
  .byte 100
  .byte 101
  .byte 109
  .byte 111
  .byte 0
.section .text
  leaq .Laot_string_690(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_617070732d72756e
  ret
.Lfranc_689:
  leaq reg_fw_616d2d6b6579(%rip), %rdi
  call fr_reg_get
  movabsq $53, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_691
.section .rodata
.Laot_string_692:
  .byte 97
  .byte 112
  .byte 112
  .byte 45
  .byte 102
  .byte 111
  .byte 114
  .byte 100
  .byte 45
  .byte 100
  .byte 101
  .byte 109
  .byte 111
  .byte 0
.section .text
  leaq .Laot_string_692(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_617070732d72756e
  ret
.Lfranc_691:
  leaq reg_fw_616d2d6b6579(%rip), %rdi
  call fr_reg_get
  movabsq $54, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_693
.section .rodata
.Laot_string_694:
  .byte 97
  .byte 112
  .byte 112
  .byte 45
  .byte 115
  .byte 112
  .byte 105
  .byte 114
  .byte 111
  .byte 45
  .byte 100
  .byte 101
  .byte 109
  .byte 111
  .byte 0
.section .text
  leaq .Laot_string_694(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_617070732d72756e
  ret
.Lfranc_693:
  leaq reg_fw_616d2d6b6579(%rip), %rdi
  call fr_reg_get
  movabsq $55, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_695
.section .rodata
.Laot_string_696:
  .byte 109
  .byte 97
  .byte 116
  .byte 104
  .byte 45
  .byte 100
  .byte 101
  .byte 109
  .byte 111
  .byte 0
.section .text
  leaq .Laot_string_696(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_617070732d72756e
  ret
.Lfranc_695:
  leaq reg_fw_616d2d6b6579(%rip), %rdi
  call fr_reg_get
  movabsq $56, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_697
.section .rodata
.Laot_string_698:
  .byte 97
  .byte 112
  .byte 112
  .byte 45
  .byte 100
  .byte 101
  .byte 109
  .byte 111
  .byte 0
.section .text
  leaq .Laot_string_698(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_617070732d72756e
  ret
.Lfranc_697:
  leaq reg_fw_616d2d6b6579(%rip), %rdi
  call fr_reg_get
  movabsq $57, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_699
.section .rodata
.Laot_string_700:
  .byte 105
  .byte 100
  .byte 101
  .byte 45
  .byte 109
  .byte 97
  .byte 105
  .byte 110
  .byte 0
.section .text
  leaq .Laot_string_700(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_617070732d72756e
  ret
.Lfranc_699:
.section .rodata
.Laot_string_701:
  .byte 63
  .byte 0
.section .text
  leaq .Laot_string_701(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  ret
fw_6170702d72656769737465722d73656564:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6167,16,16
  leaq reg_fw_6167(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6169,16,16
  leaq reg_fw_6169(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_616e,16,16
  leaq reg_fw_616e(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6171,16,16
  leaq reg_fw_6171(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6173,16,16
  leaq reg_fw_6173(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6174,16,16
  leaq reg_fw_6174(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6178,16,16
  leaq reg_fw_6178(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6361,16,16
  leaq reg_fw_6361(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_63616c632d616e73,16,16
  leaq reg_fw_63616c632d616e73(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_63616c632d63686172,16,16
  leaq reg_fw_63616c632d63686172(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_63616c632d69,16,16
  leaq reg_fw_63616c632d69(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_63616c632d6b6579,16,16
  leaq reg_fw_63616c632d6b6579(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_63616c632d6c656e,16,16
  leaq reg_fw_63616c632d6c656e(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_63616c632d70726576,16,16
  leaq reg_fw_63616c632d70726576(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_63616c632d707472,16,16
  leaq reg_fw_63616c632d707472(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_63616c632d7361766564,16,16
  leaq reg_fw_63616c632d7361766564(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_63616c632d7374617274,16,16
  leaq reg_fw_63616c632d7374617274(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6368,16,16
  leaq reg_fw_6368(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_63702d64617461,16,16
  leaq reg_fw_63702d64617461(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_63702d64657374,16,16
  leaq reg_fw_63702d64657374(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_63702d736f75726365,16,16
  leaq reg_fw_63702d736f75726365(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6378,16,16
  leaq reg_fw_6378(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6463,16,16
  leaq reg_fw_6463(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_64642d616869,16,16
  leaq reg_fw_64642d616869(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_64642d616c6f,16,16
  leaq reg_fw_64642d616c6f(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_64642d626869,16,16
  leaq reg_fw_64642d626869(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_64642d626c6f,16,16
  leaq reg_fw_64642d626c6f(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_64642d6869,16,16
  leaq reg_fw_64642d6869(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_64642d6c6f,16,16
  leaq reg_fw_64642d6c6f(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_64642d7363616c65,16,16
  leaq reg_fw_64642d7363616c65(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6469,16,16
  leaq reg_fw_6469(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_656469742d63757272656e74,16,16
  leaq reg_fw_656469742d63757272656e74(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_656469742d6e616d65,16,16
  leaq reg_fw_656469742d6e616d65(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6566,16,16
  leaq reg_fw_6566(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6569,16,16
  leaq reg_fw_6569(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_656b,16,16
  leaq reg_fw_656b(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_656e,16,16
  leaq reg_fw_656e(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6573,16,16
  leaq reg_fw_6573(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6574,16,16
  leaq reg_fw_6574(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6578,16,16
  leaq reg_fw_6578(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6661,16,16
  leaq reg_fw_6661(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6662,16,16
  leaq reg_fw_6662(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6663,16,16
  leaq reg_fw_6663(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_66636f6c6f72,16,16
  leaq reg_fw_66636f6c6f72(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6664,16,16
  leaq reg_fw_6664(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_666b,16,16
  leaq reg_fw_666b(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_666c,16,16
  leaq reg_fw_666c(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_666e,16,16
  leaq reg_fw_666e(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6670,16,16
  leaq reg_fw_6670(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6671,16,16
  leaq reg_fw_6671(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6672,16,16
  leaq reg_fw_6672(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_66722d636f6c,16,16
  leaq reg_fw_66722d636f6c(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_66722d636f6c6f72,16,16
  leaq reg_fw_66722d636f6c6f72(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_66722d686569676874,16,16
  leaq reg_fw_66722d686569676874(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_66722d726f77,16,16
  leaq reg_fw_66722d726f77(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_66722d7769647468,16,16
  leaq reg_fw_66722d7769647468(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_66722d78,16,16
  leaq reg_fw_66722d78(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_66722d79,16,16
  leaq reg_fw_66722d79(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6674,16,16
  leaq reg_fw_6674(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6675,16,16
  leaq reg_fw_6675(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6676,16,16
  leaq reg_fw_6676(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6678,16,16
  leaq reg_fw_6678(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_667863,16,16
  leaq reg_fw_667863(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_66786c,16,16
  leaq reg_fw_66786c(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_667872,16,16
  leaq reg_fw_667872(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6679,16,16
  leaq reg_fw_6679(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_667962,16,16
  leaq reg_fw_667962(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_667963,16,16
  leaq reg_fw_667963(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_667974,16,16
  leaq reg_fw_667974(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_696861,16,16
  leaq reg_fw_696861(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_696862,16,16
  leaq reg_fw_696862(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_696c61,16,16
  leaq reg_fw_696c61(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_696c62,16,16
  leaq reg_fw_696c62(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_697031,16,16
  leaq reg_fw_697031(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_697032,16,16
  leaq reg_fw_697032(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_697033,16,16
  leaq reg_fw_697033(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_697034,16,16
  leaq reg_fw_697034(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_697668,16,16
  leaq reg_fw_697668(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_69766c,16,16
  leaq reg_fw_69766c(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c61756e63682d636f6465,16,16
  leaq reg_fw_6c61756e63682d636f6465(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c61756e63682d6e616d65,16,16
  leaq reg_fw_6c61756e63682d6e616d65(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c63,16,16
  leaq reg_fw_6c63(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c64,16,16
  leaq reg_fw_6c64(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c69,16,16
  leaq reg_fw_6c69(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c6b,16,16
  leaq reg_fw_6c6b(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c6e,16,16
  leaq reg_fw_6c6e(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c6e2d636f6c6f72,16,16
  leaq reg_fw_6c6e2d636f6c6f72(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c6e2d636f756e74,16,16
  leaq reg_fw_6c6e2d636f756e74(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c6e2d6478,16,16
  leaq reg_fw_6c6e2d6478(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c6e2d6479,16,16
  leaq reg_fw_6c6e2d6479(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c6e2d69,16,16
  leaq reg_fw_6c6e2d69(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c6e2d7830,16,16
  leaq reg_fw_6c6e2d7830(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c6e2d7831,16,16
  leaq reg_fw_6c6e2d7831(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c6e2d7930,16,16
  leaq reg_fw_6c6e2d7930(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c6e2d7931,16,16
  leaq reg_fw_6c6e2d7931(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c6f61642d64617461,16,16
  leaq reg_fw_6c6f61642d64617461(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c73,16,16
  leaq reg_fw_6c73(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c73756d,16,16
  leaq reg_fw_6c73756d(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c74,16,16
  leaq reg_fw_6c74(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c7465726d,16,16
  leaq reg_fw_6c7465726d(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c75,16,16
  leaq reg_fw_6c75(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c78,16,16
  leaq reg_fw_6c78(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c79,16,16
  leaq reg_fw_6c79(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6d61,16,16
  leaq reg_fw_6d61(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6d62,16,16
  leaq reg_fw_6d62(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6d70,16,16
  leaq reg_fw_6d70(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6d7a,16,16
  leaq reg_fw_6d7a(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_706970726563,16,16
  leaq reg_fw_706970726563(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_706976616c,16,16
  leaq reg_fw_706976616c(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_706c2d626c7565,16,16
  leaq reg_fw_706c2d626c7565(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_706c2d677265656e,16,16
  leaq reg_fw_706c2d677265656e(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_706c2d696e646578,16,16
  leaq reg_fw_706c2d696e646578(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_706c2d726564,16,16
  leaq reg_fw_706c2d726564(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_706f772d62617365,16,16
  leaq reg_fw_706f772d62617365(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_706f772d6578706f6e656e74,16,16
  leaq reg_fw_706f772d6578706f6e656e74(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_706f772d726573756c74,16,16
  leaq reg_fw_706f772d726573756c74(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_70782d78,16,16
  leaq reg_fw_70782d78(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_70782d79,16,16
  leaq reg_fw_70782d79(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_7264,16,16
  leaq reg_fw_7264(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_726e,16,16
  leaq reg_fw_726e(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_7278,16,16
  leaq reg_fw_7278(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_7365,16,16
  leaq reg_fw_7365(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_7367,16,16
  leaq reg_fw_7367(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_7368,16,16
  leaq reg_fw_7368(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_7369,16,16
  leaq reg_fw_7369(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_736e,16,16
  leaq reg_fw_736e(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_7370,16,16
  leaq reg_fw_7370(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_737061,16,16
  leaq reg_fw_737061(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_7370636f6c,16,16
  leaq reg_fw_7370636f6c(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_737069,16,16
  leaq reg_fw_737069(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_73706d78,16,16
  leaq reg_fw_73706d78(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_73706e,16,16
  leaq reg_fw_73706e(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_737070,16,16
  leaq reg_fw_737070(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_737071,16,16
  leaq reg_fw_737071(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_73707363,16,16
  leaq reg_fw_73707363(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_737074,16,16
  leaq reg_fw_737074(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_737078,16,16
  leaq reg_fw_737078(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_73707878,16,16
  leaq reg_fw_73707878(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_737079,16,16
  leaq reg_fw_737079(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_73707979,16,16
  leaq reg_fw_73707979(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_7373,16,16
  leaq reg_fw_7373(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_7374,16,16
  leaq reg_fw_7374(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_7378,16,16
  leaq reg_fw_7378(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_7379,16,16
  leaq reg_fw_7379(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_747031,16,16
  leaq reg_fw_747031(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_747032,16,16
  leaq reg_fw_747032(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_747131,16,16
  leaq reg_fw_747131(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_747132,16,16
  leaq reg_fw_747132(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_776b2d6b6579,16,16
  leaq reg_fw_776b2d6b6579(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_776b2d6c,16,16
  leaq reg_fw_776b2d6c(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_776b2d6d,16,16
  leaq reg_fw_776b2d6d(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_776b2d6e65787470,16,16
  leaq reg_fw_776b2d6e65787470(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_776b2d6e65787471,16,16
  leaq reg_fw_776b2d6e65787471(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_776b2d70,16,16
  leaq reg_fw_776b2d70(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_776b2d71,16,16
  leaq reg_fw_776b2d71(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_776b2d7374657073,16,16
  leaq reg_fw_776b2d7374657073(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_776b2d75,16,16
  leaq reg_fw_776b2d75(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_776b2d76,16,16
  leaq reg_fw_776b2d76(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_626164642d61,16,16
  leaq reg_fw_626164642d61(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_626164642d62,16,16
  leaq reg_fw_626164642d62(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_626164642d6361727279,16,16
  leaq reg_fw_626164642d6361727279(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_626164642d69,16,16
  leaq reg_fw_626164642d69(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_626164642d6e,16,16
  leaq reg_fw_626164642d6e(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_626164642d72,16,16
  leaq reg_fw_626164642d72(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_626164642d73,16,16
  leaq reg_fw_626164642d73(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_626361702d70,16,16
  leaq reg_fw_626361702d70(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_62636d702d61,16,16
  leaq reg_fw_62636d702d61(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_62636d702d62,16,16
  leaq reg_fw_62636d702d62(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_62636d702d64,16,16
  leaq reg_fw_62636d702d64(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_62636d702d69,16,16
  leaq reg_fw_62636d702d69(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_62636f70792d61,16,16
  leaq reg_fw_62636f70792d61(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_62636f70792d69,16,16
  leaq reg_fw_62636f70792d69(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_62636f70792d72,16,16
  leaq reg_fw_62636f70792d72(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_626469672d69,16,16
  leaq reg_fw_626469672d69(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_626469672d70,16,16
  leaq reg_fw_626469672d70(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_626469762d64,16,16
  leaq reg_fw_626469762d64(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_626469762d69,16,16
  leaq reg_fw_626469762d69(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_626469762d70,16,16
  leaq reg_fw_626469762d70(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_626469762d72656d,16,16
  leaq reg_fw_626469762d72656d(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_626469762d76,16,16
  leaq reg_fw_626469762d76(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6266726f6d2d69,16,16
  leaq reg_fw_6266726f6d2d69(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6266726f6d2d70,16,16
  leaq reg_fw_6266726f6d2d70(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6266726f6d2d76,16,16
  leaq reg_fw_6266726f6d2d76(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_626c656e2d70,16,16
  leaq reg_fw_626c656e2d70(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_626d756c2d61,16,16
  leaq reg_fw_626d756c2d61(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_626d756c2d62,16,16
  leaq reg_fw_626d756c2d62(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_626d756c2d6361727279,16,16
  leaq reg_fw_626d756c2d6361727279(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_626d756c2d69,16,16
  leaq reg_fw_626d756c2d69(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_626d756c2d6a,16,16
  leaq reg_fw_626d756c2d6a(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_626d756c2d6b,16,16
  leaq reg_fw_626d756c2d6b(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_626d756c2d6e,16,16
  leaq reg_fw_626d756c2d6e(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_626d756c2d72,16,16
  leaq reg_fw_626d756c2d72(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_626d756c2d73,16,16
  leaq reg_fw_626d756c2d73(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_626d782d61,16,16
  leaq reg_fw_626d782d61(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_626d782d62,16,16
  leaq reg_fw_626d782d62(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_626e65772d636170,16,16
  leaq reg_fw_626e65772d636170(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_626e65772d656e64,16,16
  leaq reg_fw_626e65772d656e64(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_626e65772d69,16,16
  leaq reg_fw_626e65772d69(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_626e65772d70,16,16
  leaq reg_fw_626e65772d70(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_62706f772d657870,16,16
  leaq reg_fw_62706f772d657870(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_62706f772d70,16,16
  leaq reg_fw_62706f772d70(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_62706f772d72,16,16
  leaq reg_fw_62706f772d72(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6270722d6469676974,16,16
  leaq reg_fw_6270722d6469676974(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6270722d70,16,16
  leaq reg_fw_6270722d70(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6270722d73697a65,16,16
  leaq reg_fw_6270722d73697a65(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6270722d776f726b,16,16
  leaq reg_fw_6270722d776f726b(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_627075742d69,16,16
  leaq reg_fw_627075742d69(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_627075742d70,16,16
  leaq reg_fw_627075742d70(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_627075742d76,16,16
  leaq reg_fw_627075742d76(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_627375622d61,16,16
  leaq reg_fw_627375622d61(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_627375622d62,16,16
  leaq reg_fw_627375622d62(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_627375622d626f72726f77,16,16
  leaq reg_fw_627375622d626f72726f77(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_627375622d64,16,16
  leaq reg_fw_627375622d64(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_627375622d69,16,16
  leaq reg_fw_627375622d69(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_627375622d72,16,16
  leaq reg_fw_627375622d72(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_627472696d2d69,16,16
  leaq reg_fw_627472696d2d69(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_627472696d2d70,16,16
  leaq reg_fw_627472696d2d70(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_627a65726f2d70,16,16
  leaq reg_fw_627a65726f2d70(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_66636c2d65,16,16
  leaq reg_fw_66636c2d65(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_66636c2d6d,16,16
  leaq reg_fw_66636c2d6d(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_66636c2d70,16,16
  leaq reg_fw_66636c2d70(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_666578702d70,16,16
  leaq reg_fw_666578702d70(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_666d616e2d69,16,16
  leaq reg_fw_666d616e2d69(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_666d616e2d70,16,16
  leaq reg_fw_666d616e2d70(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_666d616e2d7363616c65,16,16
  leaq reg_fw_666d616e2d7363616c65(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_666d616e2d76,16,16
  leaq reg_fw_666d616e2d76(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_667265642d65,16,16
  leaq reg_fw_667265642d65(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_667265642d73,16,16
  leaq reg_fw_667265642d73(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6673632d65,16,16
  leaq reg_fw_6673632d65(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6673632d6d,16,16
  leaq reg_fw_6673632d6d(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6673632d70,16,16
  leaq reg_fw_6673632d70(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6673632d7368696674,16,16
  leaq reg_fw_6673632d7368696674(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6673632d76,16,16
  leaq reg_fw_6673632d76(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_667369676e2d70,16,16
  leaq reg_fw_667369676e2d70(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6674722d636c617373,16,16
  leaq reg_fw_6674722d636c617373(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6674722d64,16,16
  leaq reg_fw_6674722d64(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6674722d65,16,16
  leaq reg_fw_6674722d65(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6674722d70,16,16
  leaq reg_fw_6674722d70(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6674722d73,16,16
  leaq reg_fw_6674722d73(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c632d6368,16,16
  leaq reg_fw_6c632d6368(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c632d6572726f72,16,16
  leaq reg_fw_6c632d6572726f72(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c632d6c656e,16,16
  leaq reg_fw_6c632d6c656e(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c632d70,16,16
  leaq reg_fw_6c632d70(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c632d7370,16,16
  leaq reg_fw_6c632d7370(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c632d77616e74,16,16
  leaq reg_fw_6c632d77616e74(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c636c6f73652d63,16,16
  leaq reg_fw_6c636c6f73652d63(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c642d6368,16,16
  leaq reg_fw_6c642d6368(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c66696e6973682d63,16,16
  leaq reg_fw_6c66696e6973682d63(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c6f702d6368,16,16
  leaq reg_fw_6c6f702d6368(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c6f70657261746f722d6368,16,16
  leaq reg_fw_6c6f70657261746f722d6368(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c6f70657261746f722d746f70,16,16
  leaq reg_fw_6c6f70657261746f722d746f70(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c70632d6368,16,16
  leaq reg_fw_6c70632d6368(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c707573682d6368,16,16
  leaq reg_fw_6c707573682d6368(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c7075742d6368,16,16
  leaq reg_fw_6c7075742d6368(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6c72756e2d636f6465,16,16
  leaq reg_fw_6c72756e2d636f6465(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_706b672d6c6f61646564,16,16
  leaq reg_fw_706b672d6c6f61646564(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_706b672d6e616d65,16,16
  leaq reg_fw_706b672d6e616d65(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_706b672d736f75726365,16,16
  leaq reg_fw_706b672d736f75726365(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_75313670,16,16
  leaq reg_fw_75313670(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_75313676,16,16
  leaq reg_fw_75313676(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_75333270,16,16
  leaq reg_fw_75333270(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_75333276,16,16
  leaq reg_fw_75333276(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6964652d6174,16,16
  leaq reg_fw_6964652d6174(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6964652d637572736f72,16,16
  leaq reg_fw_6964652d637572736f72(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6964652d66696c65,16,16
  leaq reg_fw_6964652d66696c65(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6964652d66696c656e616d65,16,16
  leaq reg_fw_6964652d66696c656e616d65(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6964652d69,16,16
  leaq reg_fw_6964652d69(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6964652d6b6579,16,16
  leaq reg_fw_6964652d6b6579(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6964652d6c656e677468,16,16
  leaq reg_fw_6964652d6c656e677468(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6964652d6e,16,16
  leaq reg_fw_6964652d6e(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6964652d736f75726365,16,16
  leaq reg_fw_6964652d736f75726365(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6964652d74657874,16,16
  leaq reg_fw_6964652d74657874(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_70632d627573,16,16
  leaq reg_fw_70632d627573(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_70632d646576,16,16
  leaq reg_fw_70632d646576(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_70632d666e,16,16
  leaq reg_fw_70632d666e(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_70632d6f6666,16,16
  leaq reg_fw_70632d6f6666(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_70636c2d627573,16,16
  leaq reg_fw_70636c2d627573(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_70636c2d646576,16,16
  leaq reg_fw_70636c2d646576(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_70642d6964,16,16
  leaq reg_fw_70642d6964(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_70652d6964,16,16
  leaq reg_fw_70652d6964(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_70652d736c6f74,16,16
  leaq reg_fw_70652d736c6f74(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_7069642d627573,16,16
  leaq reg_fw_7069642d627573(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_7069642d646576,16,16
  leaq reg_fw_7069642d646576(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_706e2d736c6f74,16,16
  leaq reg_fw_706e2d736c6f74(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_70732d6964,16,16
  leaq reg_fw_70732d6964(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_70732d736c6f74,16,16
  leaq reg_fw_70732d736c6f74(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_70762d6964,16,16
  leaq reg_fw_70762d6964(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_7461736b2d61,16,16
  leaq reg_fw_7461736b2d61(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_7461736b2d62,16,16
  leaq reg_fw_7461736b2d62(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_7461736b2d636f756e74,16,16
  leaq reg_fw_7461736b2d636f756e74(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_7461736b2d646f6e65,16,16
  leaq reg_fw_7461736b2d646f6e65(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_7461736b2d656e747279,16,16
  leaq reg_fw_7461736b2d656e747279(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_7461736b2d7374657073,16,16
  leaq reg_fw_7461736b2d7374657073(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_7461736b2d7469636b73,16,16
  leaq reg_fw_7461736b2d7469636b73(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_7461736b2d7475726e,16,16
  leaq reg_fw_7461736b2d7475726e(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6e65742d616374697665,16,16
  leaq reg_fw_6e65742d616374697665(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6e65742d626172,16,16
  leaq reg_fw_6e65742d626172(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6e65742d69,16,16
  leaq reg_fw_6e65742d69(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6e65742d696f62617365,16,16
  leaq reg_fw_6e65742d696f62617365(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6e65742d6d6d696f,16,16
  leaq reg_fw_6e65742d6d6d696f(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6e65742d6a,16,16
  leaq reg_fw_6e65742d6a(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6e65742d6c656e,16,16
  leaq reg_fw_6e65742d6c656e(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6e65742d6d61636869,16,16
  leaq reg_fw_6e65742d6d61636869(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6e65742d6d61636c6f,16,16
  leaq reg_fw_6e65742d6d61636c6f(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6e65742d6f6374,16,16
  leaq reg_fw_6e65742d6f6374(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6e65742d706369636d64,16,16
  leaq reg_fw_6e65742d706369636d64(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6e65742d707472,16,16
  leaq reg_fw_6e65742d707472(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6e65742d726567,16,16
  leaq reg_fw_6e65742d726567(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6e65742d73656e74,16,16
  leaq reg_fw_6e65742d73656e74(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6e65742d73697a65,16,16
  leaq reg_fw_6e65742d73697a65(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6e65742d736c6f74,16,16
  leaq reg_fw_6e65742d736c6f74(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6e65742d737263,16,16
  leaq reg_fw_6e65742d737263(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6e65742d76616c7565,16,16
  leaq reg_fw_6e65742d76616c7565(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6669622d61,16,16
  leaq reg_fw_6669622d61(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6669622d62,16,16
  leaq reg_fw_6669622d62(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6669622d6e,16,16
  leaq reg_fw_6669622d6e(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_6669622d69,16,16
  leaq reg_fw_6669622d69(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_66742d6174,16,16
  leaq reg_fw_66742d6174(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_66742d6368,16,16
  leaq reg_fw_66742d6368(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_66742d64617461,16,16
  leaq reg_fw_66742d64617461(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_66742d64656e,16,16
  leaq reg_fw_66742d64656e(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_66742d69,16,16
  leaq reg_fw_66742d69(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_66742d6e616d65,16,16
  leaq reg_fw_66742d6e616d65(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_66742d6e616d652d6c656e677468,16,16
  leaq reg_fw_66742d6e616d652d6c656e677468(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_66742d6e756d,16,16
  leaq reg_fw_66742d6e756d(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_66742d6f6b,16,16
  leaq reg_fw_66742d6f6b(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_66742d73697a65,16,16
  leaq reg_fw_66742d73697a65(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_66742d7374657073,16,16
  leaq reg_fw_66742d7374657073(%rip), %rdi
  call fr_reg_set
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_66742d76616c7565,16,16
  leaq reg_fw_66742d76616c7565(%rip), %rdi
  call fr_reg_set
  ret
fw_62616e6e6572:
.section .rodata
.Laot_string_702:
  .byte 70
  .byte 114
  .byte 97
  .byte 110
  .byte 99
  .byte 79
  .byte 83
  .byte 32
  .byte 65
  .byte 79
  .byte 84
  .byte 32
  .byte 124
  .byte 32
  .byte 54
  .byte 52
  .byte 45
  .byte 98
  .byte 105
  .byte 116
  .byte 32
  .byte 124
  .byte 32
  .byte 110
  .byte 111
  .byte 32
  .byte 67
  .byte 32
  .byte 114
  .byte 117
  .byte 110
  .byte 116
  .byte 105
  .byte 109
  .byte 101
  .byte 0
.section .text
  leaq .Laot_string_702(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  ret
fw_6164642d74657374:
  movabsq $1, %rdi
  movabsq $3, %rsi
  call fr_push
  movabsq $1, %rdi
  movabsq $6, %rsi
  call fr_push
  call fr_add
  call fr_dot
  ret
fw_737175617265:
  call fr_dup
  call fr_mul
  ret
fw_6272616e63682d74657374:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_703
.section .rodata
.Laot_string_704:
  .byte 66
  .byte 82
  .byte 65
  .byte 78
  .byte 67
  .byte 72
  .byte 32
  .byte 79
  .byte 75
  .byte 0
.section .text
  leaq .Laot_string_704(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  jmp .Lfranc_705
.Lfranc_703:
.section .rodata
.Laot_string_706:
  .byte 66
  .byte 82
  .byte 65
  .byte 78
  .byte 67
  .byte 72
  .byte 32
  .byte 70
  .byte 65
  .byte 73
  .byte 76
  .byte 69
  .byte 68
  .byte 0
.section .text
  leaq .Laot_string_706(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
.Lfranc_705:
  ret
fw_6c6f6f702d74657374:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
.comm reg_fw_636f756e74,16,16
  leaq reg_fw_636f756e74(%rip), %rdi
  call fr_reg_set
.Lfranc_707:
  leaq reg_fw_636f756e74(%rip), %rdi
  call fr_reg_get
  movabsq $3, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jns .Lfranc_708
  leaq reg_fw_636f756e74(%rip), %rdi
  call fr_reg_get
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_add
.comm reg_fw_636f756e74,16,16
  leaq reg_fw_636f756e74(%rip), %rdi
  call fr_reg_set
  jmp .Lfranc_707
.Lfranc_708:
  leaq reg_fw_636f756e74(%rip), %rdi
  call fr_reg_get
  call fr_dot
  ret
fw_647261772d64656d6f:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_clear
  movabsq $10, %rdi
  movabsq $1, %rsi
  call fr_push
  movabsq $20, %rdi
  movabsq $1, %rsi
  call fr_push
  movabsq $14, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_pixel
  movabsq $11, %rdi
  movabsq $1, %rsi
  call fr_push
  movabsq $20, %rdi
  movabsq $1, %rsi
  call fr_push
  movabsq $15, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_pixel
  ret
fw_68617264776172653f:
  movabsq $1, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
fw_6469736b2d72656164793f:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
fw_6469736b2d666f726d6174:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
fw_686f73742d73617665:
  call fr_drop
  call fr_drop
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
fw_686f73742d736f75726365:
  call fr_drop
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
fw_686f73742d66696c6573:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_drop
  ret
fw_686f73742d6b6579:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  ret
fw_73746f72652d636865636b:
.section .rodata
.Laot_string_709:
  .byte 112
  .byte 114
  .byte 111
  .byte 111
  .byte 102
  .byte 46
  .byte 102
  .byte 114
  .byte 97
  .byte 99
  .byte 0
.section .text
  leaq .Laot_string_709(%rip), %rdi
  movq $1, %rsi
  call fr_push
.section .rodata
.Laot_string_710:
  .byte 100
  .byte 101
  .byte 102
  .byte 32
  .byte 115
  .byte 97
  .byte 118
  .byte 101
  .byte 100
  .byte 32
  .byte 55
  .byte 55
  .byte 32
  .byte 59
  .byte 0
.section .text
  leaq .Laot_string_710(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_66732d73617665
  call fr_dot
.section .rodata
.Laot_string_711:
  .byte 112
  .byte 114
  .byte 111
  .byte 111
  .byte 102
  .byte 46
  .byte 102
  .byte 114
  .byte 97
  .byte 99
  .byte 0
.section .text
  leaq .Laot_string_711(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_66732d736f75726365
.comm reg_fw_73632d707472,16,16
  leaq reg_fw_73632d707472(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_73632d707472(%rip), %rdi
  call fr_reg_get
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_712
.section .rodata
.Laot_string_713:
  .byte 83
  .byte 84
  .byte 79
  .byte 82
  .byte 65
  .byte 71
  .byte 69
  .byte 32
  .byte 76
  .byte 79
  .byte 65
  .byte 68
  .byte 32
  .byte 70
  .byte 65
  .byte 73
  .byte 76
  .byte 69
  .byte 68
  .byte 0
.section .text
  leaq .Laot_string_713(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  jmp .Lfranc_714
.Lfranc_712:
  leaq reg_fw_73632d707472(%rip), %rdi
  call fr_reg_get
  call fr_type
  call fr_cr
.section .rodata
.Laot_string_715:
  .byte 83
  .byte 84
  .byte 79
  .byte 82
  .byte 65
  .byte 71
  .byte 69
  .byte 32
  .byte 79
  .byte 75
  .byte 0
.section .text
  leaq .Laot_string_715(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
.Lfranc_714:
  ret
fw_6174612d636865636b:
  movabsq $128, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_6174612d726561642d736563746f72
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_716
.section .rodata
.Laot_string_717:
  .byte 65
  .byte 84
  .byte 65
  .byte 32
  .byte 82
  .byte 69
  .byte 65
  .byte 68
  .byte 32
  .byte 70
  .byte 65
  .byte 73
  .byte 76
  .byte 69
  .byte 68
  .byte 0
.section .text
  leaq .Laot_string_717(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  ret
.Lfranc_716:
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sector_bfetch
  call fr_dot
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  movabsq $42, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sector_bstore
  movabsq $190, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_6174612d77726974652d736563746f72
  call fr_dot
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sector_bstore
  movabsq $190, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_6174612d726561642d736563746f72
  call fr_dot
  movabsq $0, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sector_bfetch
  call fr_dot
.section .rodata
.Laot_string_718:
  .byte 65
  .byte 84
  .byte 65
  .byte 32
  .byte 87
  .byte 82
  .byte 73
  .byte 84
  .byte 69
  .byte 32
  .byte 82
  .byte 69
  .byte 65
  .byte 68
  .byte 66
  .byte 65
  .byte 67
  .byte 75
  .byte 32
  .byte 68
  .byte 79
  .byte 78
  .byte 69
  .byte 0
.section .text
  leaq .Laot_string_718(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  ret
fw_636f6e736f6c652d68656c70:
.section .rodata
.Laot_string_719:
  .byte 104
  .byte 32
  .byte 104
  .byte 101
  .byte 108
  .byte 112
  .byte 32
  .byte 32
  .byte 112
  .byte 32
  .byte 114
  .byte 97
  .byte 116
  .byte 105
  .byte 111
  .byte 110
  .byte 97
  .byte 108
  .byte 32
  .byte 32
  .byte 115
  .byte 32
  .byte 115
  .byte 116
  .byte 111
  .byte 114
  .byte 97
  .byte 103
  .byte 101
  .byte 32
  .byte 32
  .byte 103
  .byte 32
  .byte 103
  .byte 114
  .byte 97
  .byte 112
  .byte 104
  .byte 105
  .byte 99
  .byte 115
  .byte 32
  .byte 32
  .byte 114
  .byte 32
  .byte 114
  .byte 101
  .byte 112
  .byte 108
  .byte 32
  .byte 32
  .byte 98
  .byte 32
  .byte 115
  .byte 101
  .byte 108
  .byte 102
  .byte 104
  .byte 111
  .byte 115
  .byte 116
  .byte 32
  .byte 32
  .byte 97
  .byte 32
  .byte 97
  .byte 111
  .byte 116
  .byte 32
  .byte 32
  .byte 99
  .byte 32
  .byte 99
  .byte 111
  .byte 109
  .byte 112
  .byte 105
  .byte 108
  .byte 101
  .byte 32
  .byte 32
  .byte 100
  .byte 32
  .byte 99
  .byte 111
  .byte 110
  .byte 116
  .byte 114
  .byte 111
  .byte 108
  .byte 32
  .byte 32
  .byte 101
  .byte 32
  .byte 115
  .byte 116
  .byte 114
  .byte 105
  .byte 110
  .byte 103
  .byte 115
  .byte 32
  .byte 32
  .byte 102
  .byte 32
  .byte 98
  .byte 117
  .byte 110
  .byte 100
  .byte 108
  .byte 101
  .byte 32
  .byte 32
  .byte 107
  .byte 32
  .byte 107
  .byte 101
  .byte 114
  .byte 110
  .byte 101
  .byte 108
  .byte 32
  .byte 32
  .byte 108
  .byte 32
  .byte 108
  .byte 111
  .byte 97
  .byte 100
  .byte 45
  .byte 97
  .byte 112
  .byte 112
  .byte 115
  .byte 32
  .byte 32
  .byte 49
  .byte 32
  .byte 99
  .byte 97
  .byte 108
  .byte 99
  .byte 32
  .byte 50
  .byte 32
  .byte 101
  .byte 100
  .byte 105
  .byte 116
  .byte 111
  .byte 114
  .byte 32
  .byte 51
  .byte 32
  .byte 119
  .byte 97
  .byte 108
  .byte 107
  .byte 101
  .byte 114
  .byte 32
  .byte 52
  .byte 32
  .byte 99
  .byte 114
  .byte 111
  .byte 115
  .byte 115
  .byte 104
  .byte 97
  .byte 105
  .byte 114
  .byte 32
  .byte 53
  .byte 32
  .byte 70
  .byte 111
  .byte 114
  .byte 100
  .byte 32
  .byte 54
  .byte 32
  .byte 115
  .byte 112
  .byte 105
  .byte 114
  .byte 111
  .byte 32
  .byte 55
  .byte 32
  .byte 109
  .byte 97
  .byte 116
  .byte 104
  .byte 32
  .byte 56
  .byte 32
  .byte 100
  .byte 101
  .byte 109
  .byte 111
  .byte 32
  .byte 57
  .byte 32
  .byte 73
  .byte 68
  .byte 69
  .byte 32
  .byte 32
  .byte 69
  .byte 115
  .byte 99
  .byte 32
  .byte 101
  .byte 120
  .byte 105
  .byte 116
  .byte 115
  .byte 0
.section .text
  leaq .Laot_string_719(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_76632d74797065
  call fw_76632d6e65776c696e65
  ret
fw_636f6e736f6c652d6d61696e:
.section .rodata
.Laot_string_720:
  .byte 70
  .byte 82
  .byte 65
  .byte 78
  .byte 67
  .byte 32
  .byte 73
  .byte 78
  .byte 84
  .byte 69
  .byte 82
  .byte 65
  .byte 67
  .byte 84
  .byte 73
  .byte 86
  .byte 69
  .byte 32
  .byte 82
  .byte 69
  .byte 65
  .byte 68
  .byte 89
  .byte 0
.section .text
  leaq .Laot_string_720(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_76632d74797065
  call fw_76632d6e65776c696e65
  call fw_636f6e736f6c652d68656c70
.Lfranc_721:
.section .rodata
.Laot_string_722:
  .byte 70
  .byte 114
  .byte 97
  .byte 110
  .byte 99
  .byte 62
  .byte 32
  .byte 0
.section .text
  leaq .Laot_string_722(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_76632d74797065
  call fw_646b2d6b6579
.comm reg_fw_63632d6b6579,16,16
  leaq reg_fw_63632d6b6579(%rip), %rdi
  call fr_reg_set
  leaq reg_fw_63632d6b6579(%rip), %rdi
  call fr_reg_get
  movabsq $27, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_723
.section .rodata
.Laot_string_724:
  .byte 69
  .byte 88
  .byte 73
  .byte 84
  .byte 32
  .byte 67
  .byte 79
  .byte 78
  .byte 83
  .byte 79
  .byte 76
  .byte 69
  .byte 0
.section .text
  leaq .Laot_string_724(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_76632d74797065
  call fw_76632d6e65776c696e65
  ret
.Lfranc_723:
  leaq reg_fw_63632d6b6579(%rip), %rdi
  call fr_reg_get
  movabsq $107, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_725
  call fw_62756e646c652d6b65726e656c
  jmp .Lfranc_726
.Lfranc_725:
  leaq reg_fw_63632d6b6579(%rip), %rdi
  call fr_reg_get
  movabsq $102, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_727
  call fw_62756e646c652d64656d6f
  jmp .Lfranc_728
.Lfranc_727:
  leaq reg_fw_63632d6b6579(%rip), %rdi
  call fr_reg_get
  movabsq $101, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_729
  call fw_616f742d737472696e672d7265672d64656d6f
  jmp .Lfranc_730
.Lfranc_729:
  leaq reg_fw_63632d6b6579(%rip), %rdi
  call fr_reg_get
  movabsq $100, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_731
  call fw_616f742d636f6e74726f6c2d64656d6f
  jmp .Lfranc_732
.Lfranc_731:
  leaq reg_fw_63632d6b6579(%rip), %rdi
  call fr_reg_get
  movabsq $99, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_733
  call fw_616f742d70726f6772616d2d64656d6f
  jmp .Lfranc_734
.Lfranc_733:
  leaq reg_fw_63632d6b6579(%rip), %rdi
  call fr_reg_get
  movabsq $97, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_735
  call fw_616f742d64656d6f
  jmp .Lfranc_736
.Lfranc_735:
  leaq reg_fw_63632d6b6579(%rip), %rdi
  call fr_reg_get
  movabsq $98, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_737
  call fw_636f6d70696c65722d626f6f747374726170
  jmp .Lfranc_738
.Lfranc_737:
  leaq reg_fw_63632d6b6579(%rip), %rdi
  call fr_reg_get
  movabsq $114, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_739
  call fw_726c2d6d61696e
  jmp .Lfranc_740
.Lfranc_739:
  leaq reg_fw_63632d6b6579(%rip), %rdi
  call fr_reg_get
  movabsq $104, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_741
  call fw_636f6e736f6c652d68656c70
  jmp .Lfranc_742
.Lfranc_741:
  leaq reg_fw_63632d6b6579(%rip), %rdi
  call fr_reg_get
  movabsq $112, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_743
  movabsq $1, %rdi
  movabsq $3, %rsi
  call fr_push
  movabsq $1, %rdi
  movabsq $6, %rsi
  call fr_push
  call fr_add
  call fr_dot
  jmp .Lfranc_744
.Lfranc_743:
  leaq reg_fw_63632d6b6579(%rip), %rdi
  call fr_reg_get
  movabsq $115, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_745
.section .rodata
.Laot_string_746:
  .byte 112
  .byte 114
  .byte 111
  .byte 111
  .byte 102
  .byte 46
  .byte 102
  .byte 114
  .byte 97
  .byte 99
  .byte 0
.section .text
  leaq .Laot_string_746(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_66732d736f75726365
  call fw_76632d74797065
  call fw_76632d6e65776c696e65
  jmp .Lfranc_747
.Lfranc_745:
  leaq reg_fw_63632d6b6579(%rip), %rdi
  call fr_reg_get
  movabsq $103, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_748
.section .rodata
.Laot_string_749:
  .byte 71
  .byte 82
  .byte 65
  .byte 80
  .byte 72
  .byte 73
  .byte 67
  .byte 83
  .byte 32
  .byte 73
  .byte 78
  .byte 32
  .byte 70
  .byte 82
  .byte 65
  .byte 78
  .byte 67
  .byte 0
.section .text
  leaq .Laot_string_749(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_76632d74797065
  call fw_76632d6e65776c696e65
  movabsq $10, %rdi
  movabsq $1, %rsi
  call fr_push
  movabsq $160, %rdi
  movabsq $1, %rsi
  call fr_push
  movabsq $14, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_76632d706978656c
  jmp .Lfranc_750
.Lfranc_748:
  leaq reg_fw_63632d6b6579(%rip), %rdi
  call fr_reg_get
  movabsq $108, %rdi
  movabsq $1, %rsi
  call fr_push
  call fr_sub
  call fr_condition
  testq %rax, %rax
  jnz .Lfranc_751
  call fw_617070732d6c6f6164
  jmp .Lfranc_752
.Lfranc_751:
  leaq reg_fw_63632d6b6579(%rip), %rdi
  call fr_reg_get
  call fw_617070732d6d656e75
.Lfranc_752:
.Lfranc_750:
.Lfranc_747:
.Lfranc_744:
.Lfranc_742:
.Lfranc_740:
.Lfranc_738:
.Lfranc_736:
.Lfranc_734:
.Lfranc_732:
.Lfranc_730:
.Lfranc_728:
.Lfranc_726:
  jmp .Lfranc_721
  ret
fw_636f6d70696c65722d626f6f747374726170:
.section .rodata
.Laot_string_753:
  .byte 83
  .byte 69
  .byte 76
  .byte 70
  .byte 72
  .byte 79
  .byte 83
  .byte 84
  .byte 32
  .byte 83
  .byte 84
  .byte 65
  .byte 82
  .byte 84
  .byte 0
.section .text
  leaq .Laot_string_753(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
.section .rodata
.Laot_string_754:
  .byte 71
  .byte 69
  .byte 78
  .byte 32
  .byte 50
  .byte 58
  .byte 32
  .byte 0
.section .text
  leaq .Laot_string_754(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_s2_self_source
  call fw_73322d736f75726365
  call fr_dot
.section .rodata
.Laot_string_755:
  .byte 71
  .byte 69
  .byte 78
  .byte 32
  .byte 51
  .byte 58
  .byte 32
  .byte 0
.section .text
  leaq .Laot_string_755(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_s2_self_source
  call fw_73322d736f75726365
  call fr_dot
.section .rodata
.Laot_string_756:
  .byte 54
  .byte 32
  .byte 55
  .byte 32
  .byte 42
  .byte 0
.section .text
  leaq .Laot_string_756(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d636f6d70696c65
  call fr_s2_run
  call fr_dot
.section .rodata
.Laot_string_757:
  .byte 83
  .byte 69
  .byte 76
  .byte 70
  .byte 72
  .byte 79
  .byte 83
  .byte 84
  .byte 32
  .byte 79
  .byte 75
  .byte 0
.section .text
  leaq .Laot_string_757(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
  call fr_cr
  ret
fw_636f6d70696c65722d70726f6265:
.section .rodata
.Laot_string_758:
  .byte 74
  .byte 73
  .byte 84
  .byte 45
  .byte 83
  .byte 85
  .byte 77
  .byte 32
  .byte 0
.section .text
  leaq .Laot_string_758(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
.section .rodata
.Laot_string_759:
  .byte 50
  .byte 32
  .byte 51
  .byte 32
  .byte 43
  .byte 0
.section .text
  leaq .Laot_string_759(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d636f6d70696c65
  call fr_s2_run
  call fr_dot
.section .rodata
.Laot_string_760:
  .byte 74
  .byte 73
  .byte 84
  .byte 45
  .byte 68
  .byte 69
  .byte 70
  .byte 32
  .byte 0
.section .text
  leaq .Laot_string_760(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fr_type
.section .rodata
.Laot_string_761:
  .byte 100
  .byte 101
  .byte 102
  .byte 32
  .byte 103
  .byte 101
  .byte 110
  .byte 101
  .byte 114
  .byte 97
  .byte 116
  .byte 101
  .byte 100
  .byte 32
  .byte 100
  .byte 117
  .byte 112
  .byte 32
  .byte 42
  .byte 32
  .byte 59
  .byte 0
.section .text
  leaq .Laot_string_761(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d636f6d70696c65
  call fr_drop
.section .rodata
.Laot_string_762:
  .byte 54
  .byte 32
  .byte 103
  .byte 101
  .byte 110
  .byte 101
  .byte 114
  .byte 97
  .byte 116
  .byte 101
  .byte 100
  .byte 0
.section .text
  leaq .Laot_string_762(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_73322d636f6d70696c65
  call fr_s2_run
  call fr_dot
  ret
fw_626f6f74:
  call fw_646b2d696e6974
  call fw_76632d696e6974
.section .rodata
.Laot_string_763:
  .byte 70
  .byte 82
  .byte 65
  .byte 78
  .byte 67
  .byte 32
  .byte 70
  .byte 82
  .byte 65
  .byte 77
  .byte 69
  .byte 66
  .byte 85
  .byte 70
  .byte 70
  .byte 69
  .byte 82
  .byte 32
  .byte 82
  .byte 69
  .byte 65
  .byte 68
  .byte 89
  .byte 0
.section .text
  leaq .Laot_string_763(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_76632d74797065
  call fw_76632d6e65776c696e65
  call fw_62616e6e6572
  call fw_6164642d74657374
  movabsq $5, %rdi
  movabsq $1, %rsi
  call fr_push
  call fw_737175617265
  call fr_dot
  call fw_6272616e63682d74657374
  call fw_6c6f6f702d74657374
  call fw_647261772d64656d6f
  call fw_6174612d636865636b
  call fw_73746f72652d636865636b
  call fw_636f6d70696c65722d70726f6265
  call fw_757067726164652d6c6f6164
  call fr_drop
.section .rodata
.Laot_string_764:
  .byte 65
  .byte 79
  .byte 84
  .byte 32
  .byte 66
  .byte 79
  .byte 79
  .byte 84
  .byte 32
  .byte 79
  .byte 75
  .byte 0
.section .text
  leaq .Laot_string_764(%rip), %rdi
  movq $1, %rsi
  call fr_push
  call fw_76632d74797065
  call fw_76632d6e65776c696e65
  call fw_636f6e736f6c652d6d61696e
  ret
.section .rodata
.Laot_word_name_0:
  .byte 43
  .byte 0
.section .data
.Laot_word_entry_0:
  .quad 0
  .quad .Laot_word_name_0
  .quad fr_add
.section .rodata
.Laot_word_name_1:
  .byte 45
  .byte 0
.section .data
.Laot_word_entry_1:
  .quad .Laot_word_entry_0
  .quad .Laot_word_name_1
  .quad fr_sub
.section .rodata
.Laot_word_name_2:
  .byte 42
  .byte 0
.section .data
.Laot_word_entry_2:
  .quad .Laot_word_entry_1
  .quad .Laot_word_name_2
  .quad fr_mul
.section .rodata
.Laot_word_name_3:
  .byte 47
  .byte 0
.section .data
.Laot_word_entry_3:
  .quad .Laot_word_entry_2
  .quad .Laot_word_name_3
  .quad fr_div
.section .rodata
.Laot_word_name_4:
  .byte 100
  .byte 117
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_4:
  .quad .Laot_word_entry_3
  .quad .Laot_word_name_4
  .quad fr_dup
.section .rodata
.Laot_word_name_5:
  .byte 100
  .byte 114
  .byte 111
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_5:
  .quad .Laot_word_entry_4
  .quad .Laot_word_name_5
  .quad fr_drop
.section .rodata
.Laot_word_name_6:
  .byte 115
  .byte 119
  .byte 97
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_6:
  .quad .Laot_word_entry_5
  .quad .Laot_word_name_6
  .quad fr_swap
.section .rodata
.Laot_word_name_7:
  .byte 111
  .byte 118
  .byte 101
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_7:
  .quad .Laot_word_entry_6
  .quad .Laot_word_name_7
  .quad fr_over
.section .rodata
.Laot_word_name_8:
  .byte 46
  .byte 0
.section .data
.Laot_word_entry_8:
  .quad .Laot_word_entry_7
  .quad .Laot_word_name_8
  .quad fr_dot
.section .rodata
.Laot_word_name_9:
  .byte 101
  .byte 109
  .byte 105
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_9:
  .quad .Laot_word_entry_8
  .quad .Laot_word_name_9
  .quad fr_emit
.section .rodata
.Laot_word_name_10:
  .byte 116
  .byte 121
  .byte 112
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_10:
  .quad .Laot_word_entry_9
  .quad .Laot_word_name_10
  .quad fr_type
.section .rodata
.Laot_word_name_11:
  .byte 99
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_11:
  .quad .Laot_word_entry_10
  .quad .Laot_word_name_11
  .quad fr_cr
.section .rodata
.Laot_word_name_12:
  .byte 112
  .byte 105
  .byte 120
  .byte 101
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_12:
  .quad .Laot_word_entry_11
  .quad .Laot_word_name_12
  .quad fr_pixel
.section .rodata
.Laot_word_name_13:
  .byte 99
  .byte 108
  .byte 101
  .byte 97
  .byte 114
  .byte 102
  .byte 98
  .byte 0
.section .data
.Laot_word_entry_13:
  .quad .Laot_word_entry_12
  .quad .Laot_word_name_13
  .quad fr_clear
.section .rodata
.Laot_word_name_14:
  .byte 107
  .byte 101
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_14:
  .quad .Laot_word_entry_13
  .quad .Laot_word_name_14
  .quad fr_key
.section .rodata
.Laot_word_name_15:
  .byte 107
  .byte 101
  .byte 121
  .byte 63
  .byte 0
.section .data
.Laot_word_entry_15:
  .quad .Laot_word_entry_14
  .quad .Laot_word_name_15
  .quad fr_keyq
.section .rodata
.Laot_word_name_16:
  .byte 100
  .byte 101
  .byte 112
  .byte 116
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_16:
  .quad .Laot_word_entry_15
  .quad .Laot_word_name_16
  .quad fr_depth
.section .rodata
.Laot_word_name_17:
  .byte 110
  .byte 101
  .byte 103
  .byte 0
.section .data
.Laot_word_entry_17:
  .quad .Laot_word_entry_16
  .quad .Laot_word_name_17
  .quad fr_neg
.section .rodata
.Laot_word_name_18:
  .byte 97
  .byte 98
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_18:
  .quad .Laot_word_entry_17
  .quad .Laot_word_name_18
  .quad fr_abs
.section .rodata
.Laot_word_name_19:
  .byte 102
  .byte 108
  .byte 111
  .byte 111
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_19:
  .quad .Laot_word_entry_18
  .quad .Laot_word_name_19
  .quad fr_floor
.section .rodata
.Laot_word_name_20:
  .byte 98
  .byte 64
  .byte 0
.section .data
.Laot_word_entry_20:
  .quad .Laot_word_entry_19
  .quad .Laot_word_name_20
  .quad fr_bfetch
.section .rodata
.Laot_word_name_21:
  .byte 98
  .byte 33
  .byte 0
.section .data
.Laot_word_entry_21:
  .quad .Laot_word_entry_20
  .quad .Laot_word_name_21
  .quad fr_bstore
.section .rodata
.Laot_word_name_22:
  .byte 105
  .byte 111
  .byte 56
  .byte 64
  .byte 0
.section .data
.Laot_word_entry_22:
  .quad .Laot_word_entry_21
  .quad .Laot_word_name_22
  .quad fr_inb
.section .rodata
.Laot_word_name_23:
  .byte 105
  .byte 111
  .byte 56
  .byte 33
  .byte 0
.section .data
.Laot_word_entry_23:
  .quad .Laot_word_entry_22
  .quad .Laot_word_name_23
  .quad fr_outb
.section .rodata
.Laot_word_name_24:
  .byte 105
  .byte 111
  .byte 49
  .byte 54
  .byte 64
  .byte 0
.section .data
.Laot_word_entry_24:
  .quad .Laot_word_entry_23
  .quad .Laot_word_name_24
  .quad fr_inw
.section .rodata
.Laot_word_name_25:
  .byte 105
  .byte 111
  .byte 49
  .byte 54
  .byte 33
  .byte 0
.section .data
.Laot_word_entry_25:
  .quad .Laot_word_entry_24
  .quad .Laot_word_name_25
  .quad fr_outw
.section .rodata
.Laot_word_name_26:
  .byte 105
  .byte 111
  .byte 51
  .byte 50
  .byte 64
  .byte 0
.section .data
.Laot_word_entry_26:
  .quad .Laot_word_entry_25
  .quad .Laot_word_name_26
  .quad fr_inl
.section .rodata
.Laot_word_name_27:
  .byte 105
  .byte 111
  .byte 51
  .byte 50
  .byte 33
  .byte 0
.section .data
.Laot_word_entry_27:
  .quad .Laot_word_entry_26
  .quad .Laot_word_name_27
  .quad fr_outl
.section .rodata
.Laot_word_name_28:
  .byte 109
  .byte 109
  .byte 105
  .byte 111
  .byte 51
  .byte 50
  .byte 64
  .byte 0
.section .data
.Laot_word_entry_28:
  .quad .Laot_word_entry_27
  .quad .Laot_word_name_28
  .quad fr_mmio32_fetch
.section .rodata
.Laot_word_name_29:
  .byte 109
  .byte 109
  .byte 105
  .byte 111
  .byte 51
  .byte 50
  .byte 33
  .byte 0
.section .data
.Laot_word_entry_29:
  .quad .Laot_word_entry_28
  .quad .Laot_word_name_29
  .quad fr_mmio32_store
.section .rodata
.Laot_word_name_30:
  .byte 98
  .byte 97
  .byte 110
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_30:
  .quad .Laot_word_entry_29
  .quad .Laot_word_name_30
  .quad fr_band
.section .rodata
.Laot_word_name_31:
  .byte 115
  .byte 101
  .byte 99
  .byte 116
  .byte 111
  .byte 114
  .byte 45
  .byte 98
  .byte 121
  .byte 116
  .byte 101
  .byte 64
  .byte 0
.section .data
.Laot_word_entry_31:
  .quad .Laot_word_entry_30
  .quad .Laot_word_name_31
  .quad fr_sector_bfetch
.section .rodata
.Laot_word_name_32:
  .byte 115
  .byte 101
  .byte 99
  .byte 116
  .byte 111
  .byte 114
  .byte 45
  .byte 98
  .byte 121
  .byte 116
  .byte 101
  .byte 33
  .byte 0
.section .data
.Laot_word_entry_32:
  .quad .Laot_word_entry_31
  .quad .Laot_word_name_32
  .quad fr_sector_bstore
.section .rodata
.Laot_word_name_33:
  .byte 115
  .byte 101
  .byte 99
  .byte 116
  .byte 111
  .byte 114
  .byte 45
  .byte 98
  .byte 117
  .byte 102
  .byte 102
  .byte 101
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_33:
  .quad .Laot_word_entry_32
  .quad .Laot_word_name_33
  .quad fr_sector_buf
.section .rodata
.Laot_word_name_34:
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 45
  .byte 98
  .byte 117
  .byte 102
  .byte 102
  .byte 101
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_34:
  .quad .Laot_word_entry_33
  .quad .Laot_word_name_34
  .quad fr_source_buffer
.section .rodata
.Laot_word_name_35:
  .byte 102
  .byte 111
  .byte 110
  .byte 116
  .byte 45
  .byte 98
  .byte 97
  .byte 115
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_35:
  .quad .Laot_word_entry_34
  .quad .Laot_word_name_35
  .quad fr_font_base
.section .rodata
.Laot_word_name_36:
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 45
  .byte 98
  .byte 121
  .byte 116
  .byte 101
  .byte 33
  .byte 0
.section .data
.Laot_word_entry_36:
  .quad .Laot_word_entry_35
  .quad .Laot_word_name_36
  .quad fr_source_bstore
.section .rodata
.Laot_word_name_37:
  .byte 98
  .byte 121
  .byte 116
  .byte 101
  .byte 64
  .byte 0
.section .data
.Laot_word_entry_37:
  .quad .Laot_word_entry_36
  .quad .Laot_word_name_37
  .quad fr_bfetch
.section .rodata
.Laot_word_name_38:
  .byte 37
  .byte 0
.section .data
.Laot_word_entry_38:
  .quad .Laot_word_entry_37
  .quad .Laot_word_name_38
  .quad fr_mod
.section .rodata
.Laot_word_name_39:
  .byte 100
  .byte 105
  .byte 99
  .byte 116
  .byte 45
  .byte 104
  .byte 101
  .byte 97
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_39:
  .quad .Laot_word_entry_38
  .quad .Laot_word_name_39
  .quad fr_dict_head
.section .rodata
.Laot_word_name_40:
  .byte 100
  .byte 105
  .byte 99
  .byte 116
  .byte 45
  .byte 110
  .byte 101
  .byte 120
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_40:
  .quad .Laot_word_entry_39
  .quad .Laot_word_name_40
  .quad fr_dict_next
.section .rodata
.Laot_word_name_41:
  .byte 100
  .byte 105
  .byte 99
  .byte 116
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_41:
  .quad .Laot_word_entry_40
  .quad .Laot_word_name_41
  .quad fr_dict_name
.section .rodata
.Laot_word_name_42:
  .byte 100
  .byte 105
  .byte 99
  .byte 116
  .byte 45
  .byte 99
  .byte 111
  .byte 100
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_42:
  .quad .Laot_word_entry_41
  .quad .Laot_word_name_42
  .quad fr_dict_code
.section .rodata
.Laot_word_name_43:
  .byte 115
  .byte 50
  .byte 45
  .byte 116
  .byte 111
  .byte 107
  .byte 101
  .byte 110
  .byte 45
  .byte 98
  .byte 117
  .byte 102
  .byte 102
  .byte 101
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_43:
  .quad .Laot_word_entry_42
  .quad .Laot_word_name_43
  .quad fr_s2_token_buffer
.section .rodata
.Laot_word_name_44:
  .byte 115
  .byte 50
  .byte 45
  .byte 108
  .byte 105
  .byte 110
  .byte 101
  .byte 45
  .byte 98
  .byte 117
  .byte 102
  .byte 102
  .byte 101
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_44:
  .quad .Laot_word_entry_43
  .quad .Laot_word_name_44
  .quad fr_s2_line_buffer
.section .rodata
.Laot_word_name_45:
  .byte 115
  .byte 50
  .byte 45
  .byte 99
  .byte 111
  .byte 110
  .byte 116
  .byte 114
  .byte 111
  .byte 108
  .byte 45
  .byte 98
  .byte 117
  .byte 102
  .byte 102
  .byte 101
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_45:
  .quad .Laot_word_entry_44
  .quad .Laot_word_name_45
  .quad fr_s2_control_buffer
.section .rodata
.Laot_word_name_46:
  .byte 115
  .byte 50
  .byte 45
  .byte 99
  .byte 111
  .byte 100
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_46:
  .quad .Laot_word_entry_45
  .quad .Laot_word_name_46
  .quad fr_s2_code
.section .rodata
.Laot_word_name_47:
  .byte 115
  .byte 50
  .byte 45
  .byte 114
  .byte 117
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_47:
  .quad .Laot_word_entry_46
  .quad .Laot_word_name_47
  .quad fr_s2_run
.section .rodata
.Laot_word_name_48:
  .byte 115
  .byte 50
  .byte 45
  .byte 100
  .byte 101
  .byte 102
  .byte 105
  .byte 110
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_48:
  .quad .Laot_word_entry_47
  .quad .Laot_word_name_48
  .quad fr_s2_define
.section .rodata
.Laot_word_name_49:
  .byte 115
  .byte 50
  .byte 45
  .byte 105
  .byte 110
  .byte 116
  .byte 101
  .byte 114
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_49:
  .quad .Laot_word_entry_48
  .quad .Laot_word_name_49
  .quad fr_s2_intern
.section .rodata
.Laot_word_name_50:
  .byte 115
  .byte 50
  .byte 45
  .byte 108
  .byte 105
  .byte 116
  .byte 45
  .byte 97
  .byte 100
  .byte 100
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_50:
  .quad .Laot_word_entry_49
  .quad .Laot_word_name_50
  .quad fr_s2_lit_addr
.section .rodata
.Laot_word_name_51:
  .byte 115
  .byte 50
  .byte 45
  .byte 115
  .byte 105
  .byte 103
  .byte 110
  .byte 45
  .byte 97
  .byte 100
  .byte 100
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_51:
  .quad .Laot_word_entry_50
  .quad .Laot_word_name_51
  .quad fr_s2_sign_addr
.section .rodata
.Laot_word_name_52:
  .byte 115
  .byte 50
  .byte 45
  .byte 115
  .byte 116
  .byte 114
  .byte 105
  .byte 110
  .byte 103
  .byte 45
  .byte 97
  .byte 100
  .byte 100
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_52:
  .quad .Laot_word_entry_51
  .quad .Laot_word_name_52
  .quad fr_s2_string_addr
.section .rodata
.Laot_word_name_53:
  .byte 114
  .byte 101
  .byte 112
  .byte 108
  .byte 45
  .byte 98
  .byte 117
  .byte 102
  .byte 102
  .byte 101
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_53:
  .quad .Laot_word_entry_52
  .quad .Laot_word_name_53
  .quad fr_repl_buffer
.section .rodata
.Laot_word_name_54:
  .byte 97
  .byte 108
  .byte 108
  .byte 111
  .byte 99
  .byte 0
.section .data
.Laot_word_entry_54:
  .quad .Laot_word_entry_53
  .quad .Laot_word_name_54
  .quad fr_heap_alloc
.section .rodata
.Laot_word_name_55:
  .byte 104
  .byte 101
  .byte 97
  .byte 112
  .byte 45
  .byte 102
  .byte 114
  .byte 101
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_55:
  .quad .Laot_word_entry_54
  .quad .Laot_word_name_55
  .quad fr_heap_available
.section .rodata
.Laot_word_name_56:
  .byte 102
  .byte 105
  .byte 98
  .byte 101
  .byte 114
  .byte 45
  .byte 115
  .byte 112
  .byte 97
  .byte 119
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_56:
  .quad .Laot_word_entry_55
  .quad .Laot_word_name_56
  .quad fr_fiber_spawn
.section .rodata
.Laot_word_name_57:
  .byte 102
  .byte 105
  .byte 98
  .byte 101
  .byte 114
  .byte 45
  .byte 115
  .byte 116
  .byte 101
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_57:
  .quad .Laot_word_entry_56
  .quad .Laot_word_name_57
  .quad fr_fiber_step
.section .rodata
.Laot_word_name_58:
  .byte 102
  .byte 105
  .byte 98
  .byte 101
  .byte 114
  .byte 45
  .byte 121
  .byte 105
  .byte 101
  .byte 108
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_58:
  .quad .Laot_word_entry_57
  .quad .Laot_word_name_58
  .quad fr_fiber_yield
.section .rodata
.Laot_word_name_59:
  .byte 102
  .byte 105
  .byte 98
  .byte 101
  .byte 114
  .byte 45
  .byte 97
  .byte 99
  .byte 116
  .byte 105
  .byte 118
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_59:
  .quad .Laot_word_entry_58
  .quad .Laot_word_name_59
  .quad fr_fiber_active
.section .rodata
.Laot_word_name_60:
  .byte 112
  .byte 97
  .byte 103
  .byte 101
  .byte 45
  .byte 97
  .byte 108
  .byte 108
  .byte 111
  .byte 99
  .byte 0
.section .data
.Laot_word_entry_60:
  .quad .Laot_word_entry_59
  .quad .Laot_word_name_60
  .quad fr_page_alloc
.section .rodata
.Laot_word_name_61:
  .byte 112
  .byte 97
  .byte 103
  .byte 101
  .byte 45
  .byte 102
  .byte 114
  .byte 101
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_61:
  .quad .Laot_word_entry_60
  .quad .Laot_word_name_61
  .quad fr_page_free
.section .rodata
.Laot_word_name_62:
  .byte 112
  .byte 97
  .byte 103
  .byte 101
  .byte 45
  .byte 102
  .byte 114
  .byte 101
  .byte 101
  .byte 45
  .byte 99
  .byte 111
  .byte 117
  .byte 110
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_62:
  .quad .Laot_word_entry_61
  .quad .Laot_word_name_62
  .quad fr_page_free_count
.section .rodata
.Laot_word_name_63:
  .byte 102
  .byte 116
  .byte 45
  .byte 115
  .byte 104
  .byte 97
  .byte 50
  .byte 53
  .byte 54
  .byte 0
.section .data
.Laot_word_entry_63:
  .quad .Laot_word_entry_62
  .quad .Laot_word_name_63
  .quad fr_ft_sha256
.section .rodata
.Laot_word_name_64:
  .byte 115
  .byte 104
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_64:
  .quad .Laot_word_entry_63
  .quad .Laot_word_name_64
  .quad fr_lshift
.section .rodata
.Laot_word_name_65:
  .byte 115
  .byte 104
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_65:
  .quad .Laot_word_entry_64
  .quad .Laot_word_name_65
  .quad fr_rshift
.section .rodata
.Laot_word_name_66:
  .byte 60
  .byte 60
  .byte 0
.section .data
.Laot_word_entry_66:
  .quad .Laot_word_entry_65
  .quad .Laot_word_name_66
  .quad fr_lshift
.section .rodata
.Laot_word_name_67:
  .byte 62
  .byte 62
  .byte 0
.section .data
.Laot_word_entry_67:
  .quad .Laot_word_entry_66
  .quad .Laot_word_name_67
  .quad fr_rshift
.section .rodata
.Laot_word_name_68:
  .byte 115
  .byte 50
  .byte 45
  .byte 115
  .byte 101
  .byte 108
  .byte 102
  .byte 45
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_68:
  .quad .Laot_word_entry_67
  .quad .Laot_word_name_68
  .quad fr_s2_self_source
.section .rodata
.Laot_word_name_69:
  .byte 33
  .byte 0
.section .data
.Laot_word_entry_69:
  .quad .Laot_word_entry_68
  .quad .Laot_word_name_69
  .quad fr_bstore
.section .rodata
.Laot_word_name_70:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 98
  .byte 117
  .byte 110
  .byte 100
  .byte 108
  .byte 101
  .byte 45
  .byte 97
  .byte 114
  .byte 101
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_70:
  .quad .Laot_word_entry_69
  .quad .Laot_word_name_70
  .quad fr_aot_bundle_area
.section .rodata
.Laot_word_name_71:
  .byte 97
  .byte 116
  .byte 45
  .byte 119
  .byte 97
  .byte 105
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_71:
  .quad .Laot_word_entry_70
  .quad .Laot_word_name_71
  .quad fw_61742d77616974
.section .rodata
.Laot_word_name_72:
  .byte 97
  .byte 116
  .byte 97
  .byte 45
  .byte 114
  .byte 101
  .byte 97
  .byte 100
  .byte 45
  .byte 115
  .byte 101
  .byte 99
  .byte 116
  .byte 111
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_72:
  .quad .Laot_word_entry_71
  .quad .Laot_word_name_72
  .quad fw_6174612d726561642d736563746f72
.section .rodata
.Laot_word_name_73:
  .byte 97
  .byte 116
  .byte 97
  .byte 45
  .byte 104
  .byte 101
  .byte 97
  .byte 100
  .byte 101
  .byte 114
  .byte 45
  .byte 98
  .byte 121
  .byte 116
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_73:
  .quad .Laot_word_entry_72
  .quad .Laot_word_name_73
  .quad fw_6174612d6865616465722d62797465
.section .rodata
.Laot_word_name_74:
  .byte 97
  .byte 116
  .byte 97
  .byte 45
  .byte 114
  .byte 101
  .byte 97
  .byte 100
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_74:
  .quad .Laot_word_entry_73
  .quad .Laot_word_name_74
  .quad fw_6174612d7265616479
.section .rodata
.Laot_word_name_75:
  .byte 97
  .byte 116
  .byte 97
  .byte 45
  .byte 119
  .byte 114
  .byte 105
  .byte 116
  .byte 101
  .byte 45
  .byte 115
  .byte 101
  .byte 99
  .byte 116
  .byte 111
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_75:
  .quad .Laot_word_entry_74
  .quad .Laot_word_name_75
  .quad fw_6174612d77726974652d736563746f72
.section .rodata
.Laot_word_name_76:
  .byte 102
  .byte 115
  .byte 45
  .byte 108
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_76:
  .quad .Laot_word_entry_75
  .quad .Laot_word_name_76
  .quad fw_66732d6c656e
.section .rodata
.Laot_word_name_77:
  .byte 102
  .byte 115
  .byte 45
  .byte 122
  .byte 101
  .byte 114
  .byte 111
  .byte 0
.section .data
.Laot_word_entry_77:
  .quad .Laot_word_entry_76
  .quad .Laot_word_name_77
  .quad fw_66732d7a65726f
.section .rodata
.Laot_word_name_78:
  .byte 102
  .byte 115
  .byte 45
  .byte 109
  .byte 97
  .byte 103
  .byte 105
  .byte 99
  .byte 63
  .byte 0
.section .data
.Laot_word_entry_78:
  .quad .Laot_word_entry_77
  .quad .Laot_word_name_78
  .quad fw_66732d6d616769633f
.section .rodata
.Laot_word_name_79:
  .byte 102
  .byte 115
  .byte 45
  .byte 114
  .byte 101
  .byte 97
  .byte 100
  .byte 121
  .byte 63
  .byte 0
.section .data
.Laot_word_entry_79:
  .quad .Laot_word_entry_78
  .quad .Laot_word_name_79
  .quad fw_66732d72656164793f
.section .rodata
.Laot_word_name_80:
  .byte 102
  .byte 115
  .byte 45
  .byte 102
  .byte 111
  .byte 114
  .byte 109
  .byte 97
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_80:
  .quad .Laot_word_entry_79
  .quad .Laot_word_name_80
  .quad fw_66732d666f726d6174
.section .rodata
.Laot_word_name_81:
  .byte 102
  .byte 115
  .byte 45
  .byte 109
  .byte 97
  .byte 116
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_81:
  .quad .Laot_word_entry_80
  .quad .Laot_word_name_81
  .quad fw_66732d6d61746368
.section .rodata
.Laot_word_name_82:
  .byte 102
  .byte 115
  .byte 45
  .byte 102
  .byte 105
  .byte 110
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_82:
  .quad .Laot_word_entry_81
  .quad .Laot_word_name_82
  .quad fw_66732d66696e64
.section .rodata
.Laot_word_name_83:
  .byte 102
  .byte 115
  .byte 45
  .byte 102
  .byte 114
  .byte 101
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_83:
  .quad .Laot_word_entry_82
  .quad .Laot_word_name_83
  .quad fw_66732d66726565
.section .rodata
.Laot_word_name_84:
  .byte 102
  .byte 115
  .byte 45
  .byte 115
  .byte 97
  .byte 118
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_84:
  .quad .Laot_word_entry_83
  .quad .Laot_word_name_84
  .quad fw_66732d73617665
.section .rodata
.Laot_word_name_85:
  .byte 102
  .byte 115
  .byte 45
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_85:
  .quad .Laot_word_entry_84
  .quad .Laot_word_name_85
  .quad fw_66732d736f75726365
.section .rodata
.Laot_word_name_86:
  .byte 102
  .byte 115
  .byte 45
  .byte 102
  .byte 105
  .byte 108
  .byte 101
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_86:
  .quad .Laot_word_entry_85
  .quad .Laot_word_name_86
  .quad fw_66732d66696c6573
.section .rodata
.Laot_word_name_87:
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_87:
  .quad .Laot_word_entry_86
  .quad .Laot_word_name_87
  .quad fw_736f75726365
.section .rodata
.Laot_word_name_88:
  .byte 115
  .byte 97
  .byte 118
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_88:
  .quad .Laot_word_entry_87
  .quad .Laot_word_name_88
  .quad fw_73617665
.section .rodata
.Laot_word_name_89:
  .byte 102
  .byte 105
  .byte 108
  .byte 101
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_89:
  .quad .Laot_word_entry_88
  .quad .Laot_word_name_89
  .quad fw_66696c6573
.section .rodata
.Laot_word_name_90:
  .byte 118
  .byte 99
  .byte 45
  .byte 105
  .byte 110
  .byte 105
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_90:
  .quad .Laot_word_entry_89
  .quad .Laot_word_name_90
  .quad fw_76632d696e6974
.section .rodata
.Laot_word_name_91:
  .byte 118
  .byte 99
  .byte 45
  .byte 112
  .byte 105
  .byte 120
  .byte 101
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_91:
  .quad .Laot_word_entry_90
  .quad .Laot_word_name_91
  .quad fw_76632d706978656c
.section .rodata
.Laot_word_name_92:
  .byte 118
  .byte 99
  .byte 45
  .byte 99
  .byte 108
  .byte 101
  .byte 97
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_92:
  .quad .Laot_word_entry_91
  .quad .Laot_word_name_92
  .quad fw_76632d636c656172
.section .rodata
.Laot_word_name_93:
  .byte 118
  .byte 99
  .byte 45
  .byte 103
  .byte 108
  .byte 121
  .byte 112
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_93:
  .quad .Laot_word_entry_92
  .quad .Laot_word_name_93
  .quad fw_76632d676c797068
.section .rodata
.Laot_word_name_94:
  .byte 118
  .byte 99
  .byte 45
  .byte 115
  .byte 99
  .byte 114
  .byte 111
  .byte 108
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_94:
  .quad .Laot_word_entry_93
  .quad .Laot_word_name_94
  .quad fw_76632d7363726f6c6c
.section .rodata
.Laot_word_name_95:
  .byte 118
  .byte 99
  .byte 45
  .byte 115
  .byte 99
  .byte 114
  .byte 111
  .byte 108
  .byte 108
  .byte 63
  .byte 0
.section .data
.Laot_word_entry_95:
  .quad .Laot_word_entry_94
  .quad .Laot_word_name_95
  .quad fw_76632d7363726f6c6c3f
.section .rodata
.Laot_word_name_96:
  .byte 118
  .byte 99
  .byte 45
  .byte 112
  .byte 117
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_96:
  .quad .Laot_word_entry_95
  .quad .Laot_word_name_96
  .quad fw_76632d707574
.section .rodata
.Laot_word_name_97:
  .byte 118
  .byte 99
  .byte 45
  .byte 116
  .byte 121
  .byte 112
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_97:
  .quad .Laot_word_entry_96
  .quad .Laot_word_name_97
  .quad fw_76632d74797065
.section .rodata
.Laot_word_name_98:
  .byte 118
  .byte 99
  .byte 45
  .byte 104
  .byte 111
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_98:
  .quad .Laot_word_entry_97
  .quad .Laot_word_name_98
  .quad fw_76632d686f6d65
.section .rodata
.Laot_word_name_99:
  .byte 118
  .byte 99
  .byte 45
  .byte 110
  .byte 101
  .byte 119
  .byte 108
  .byte 105
  .byte 110
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_99:
  .quad .Laot_word_entry_98
  .quad .Laot_word_name_99
  .quad fw_76632d6e65776c696e65
.section .rodata
.Laot_word_name_100:
  .byte 100
  .byte 107
  .byte 45
  .byte 105
  .byte 110
  .byte 105
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_100:
  .quad .Laot_word_entry_99
  .quad .Laot_word_name_100
  .quad fw_646b2d696e6974
.section .rodata
.Laot_word_name_101:
  .byte 100
  .byte 107
  .byte 45
  .byte 109
  .byte 97
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_101:
  .quad .Laot_word_entry_100
  .quad .Laot_word_name_101
  .quad fw_646b2d6d6170
.section .rodata
.Laot_word_name_102:
  .byte 100
  .byte 107
  .byte 45
  .byte 115
  .byte 99
  .byte 97
  .byte 110
  .byte 99
  .byte 111
  .byte 100
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_102:
  .quad .Laot_word_entry_101
  .quad .Laot_word_name_102
  .quad fw_646b2d7363616e636f6465
.section .rodata
.Laot_word_name_103:
  .byte 100
  .byte 107
  .byte 45
  .byte 112
  .byte 115
  .byte 50
  .byte 45
  .byte 112
  .byte 111
  .byte 108
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_103:
  .quad .Laot_word_entry_102
  .quad .Laot_word_name_103
  .quad fw_646b2d7073322d706f6c6c
.section .rodata
.Laot_word_name_104:
  .byte 100
  .byte 107
  .byte 45
  .byte 112
  .byte 111
  .byte 108
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_104:
  .quad .Laot_word_entry_103
  .quad .Laot_word_name_104
  .quad fw_646b2d706f6c6c
.section .rodata
.Laot_word_name_105:
  .byte 100
  .byte 107
  .byte 45
  .byte 107
  .byte 101
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_105:
  .quad .Laot_word_entry_104
  .quad .Laot_word_name_105
  .quad fw_646b2d6b6579
.section .rodata
.Laot_word_name_106:
  .byte 107
  .byte 101
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_106:
  .quad .Laot_word_entry_105
  .quad .Laot_word_name_106
  .quad fw_6b6579
.section .rodata
.Laot_word_name_107:
  .byte 115
  .byte 50
  .byte 45
  .byte 101
  .byte 113
  .byte 0
.section .data
.Laot_word_entry_107:
  .quad .Laot_word_entry_106
  .quad .Laot_word_name_107
  .quad fw_73322d6571
.section .rodata
.Laot_word_name_108:
  .byte 115
  .byte 50
  .byte 45
  .byte 102
  .byte 105
  .byte 110
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_108:
  .quad .Laot_word_entry_107
  .quad .Laot_word_name_108
  .quad fw_73322d66696e64
.section .rodata
.Laot_word_name_109:
  .byte 115
  .byte 50
  .byte 45
  .byte 99
  .byte 111
  .byte 112
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_109:
  .quad .Laot_word_entry_108
  .quad .Laot_word_name_109
  .quad fw_73322d636f7079
.section .rodata
.Laot_word_name_110:
  .byte 115
  .byte 50
  .byte 45
  .byte 110
  .byte 101
  .byte 120
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_110:
  .quad .Laot_word_entry_109
  .quad .Laot_word_name_110
  .quad fw_73322d6e657874
.section .rodata
.Laot_word_name_111:
  .byte 115
  .byte 50
  .byte 45
  .byte 100
  .byte 105
  .byte 103
  .byte 105
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_111:
  .quad .Laot_word_entry_110
  .quad .Laot_word_name_111
  .quad fw_73322d6469676974
.section .rodata
.Laot_word_name_112:
  .byte 115
  .byte 50
  .byte 45
  .byte 117
  .byte 105
  .byte 110
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_112:
  .quad .Laot_word_entry_111
  .quad .Laot_word_name_112
  .quad fw_73322d75696e74
.section .rodata
.Laot_word_name_113:
  .byte 115
  .byte 50
  .byte 45
  .byte 100
  .byte 101
  .byte 99
  .byte 112
  .byte 97
  .byte 114
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_113:
  .quad .Laot_word_entry_112
  .quad .Laot_word_name_113
  .quad fw_73322d64656370617274
.section .rodata
.Laot_word_name_114:
  .byte 115
  .byte 50
  .byte 45
  .byte 110
  .byte 117
  .byte 109
  .byte 98
  .byte 101
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_114:
  .quad .Laot_word_entry_113
  .quad .Laot_word_name_114
  .quad fw_73322d6e756d626572
.section .rodata
.Laot_word_name_115:
  .byte 115
  .byte 50
  .byte 45
  .byte 98
  .byte 121
  .byte 116
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_115:
  .quad .Laot_word_entry_114
  .quad .Laot_word_name_115
  .quad fw_73322d62797465
.section .rodata
.Laot_word_name_116:
  .byte 115
  .byte 50
  .byte 45
  .byte 117
  .byte 54
  .byte 52
  .byte 0
.section .data
.Laot_word_entry_116:
  .quad .Laot_word_entry_115
  .quad .Laot_word_name_116
  .quad fw_73322d753634
.section .rodata
.Laot_word_name_117:
  .byte 115
  .byte 50
  .byte 45
  .byte 99
  .byte 97
  .byte 108
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_117:
  .quad .Laot_word_entry_116
  .quad .Laot_word_name_117
  .quad fw_73322d63616c6c
.section .rodata
.Laot_word_name_118:
  .byte 115
  .byte 50
  .byte 45
  .byte 108
  .byte 105
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_118:
  .quad .Laot_word_entry_117
  .quad .Laot_word_name_118
  .quad fw_73322d6c6974
.section .rodata
.Laot_word_name_119:
  .byte 115
  .byte 50
  .byte 45
  .byte 112
  .byte 114
  .byte 111
  .byte 108
  .byte 111
  .byte 103
  .byte 117
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_119:
  .quad .Laot_word_entry_118
  .quad .Laot_word_name_119
  .quad fw_73322d70726f6c6f677565
.section .rodata
.Laot_word_name_120:
  .byte 115
  .byte 50
  .byte 45
  .byte 101
  .byte 112
  .byte 105
  .byte 108
  .byte 111
  .byte 103
  .byte 117
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_120:
  .quad .Laot_word_entry_119
  .quad .Laot_word_name_120
  .quad fw_73322d6570696c6f677565
.section .rodata
.Laot_word_name_121:
  .byte 115
  .byte 50
  .byte 45
  .byte 117
  .byte 51
  .byte 50
  .byte 0
.section .data
.Laot_word_entry_121:
  .quad .Laot_word_entry_120
  .quad .Laot_word_name_121
  .quad fw_73322d753332
.section .rodata
.Laot_word_name_122:
  .byte 115
  .byte 50
  .byte 45
  .byte 119
  .byte 114
  .byte 105
  .byte 116
  .byte 101
  .byte 54
  .byte 52
  .byte 0
.section .data
.Laot_word_entry_122:
  .quad .Laot_word_entry_121
  .quad .Laot_word_name_122
  .quad fw_73322d77726974653634
.section .rodata
.Laot_word_name_123:
  .byte 115
  .byte 50
  .byte 45
  .byte 114
  .byte 101
  .byte 97
  .byte 100
  .byte 54
  .byte 52
  .byte 0
.section .data
.Laot_word_entry_123:
  .quad .Laot_word_entry_122
  .quad .Laot_word_name_123
  .quad fw_73322d726561643634
.section .rodata
.Laot_word_name_124:
  .byte 115
  .byte 50
  .byte 45
  .byte 99
  .byte 116
  .byte 114
  .byte 108
  .byte 45
  .byte 112
  .byte 117
  .byte 115
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_124:
  .quad .Laot_word_entry_123
  .quad .Laot_word_name_124
  .quad fw_73322d6374726c2d70757368
.section .rodata
.Laot_word_name_125:
  .byte 115
  .byte 50
  .byte 45
  .byte 99
  .byte 116
  .byte 114
  .byte 108
  .byte 45
  .byte 112
  .byte 111
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_125:
  .quad .Laot_word_entry_124
  .quad .Laot_word_name_125
  .quad fw_73322d6374726c2d706f70
.section .rodata
.Laot_word_name_126:
  .byte 115
  .byte 50
  .byte 45
  .byte 112
  .byte 97
  .byte 116
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_126:
  .quad .Laot_word_entry_125
  .quad .Laot_word_name_126
  .quad fw_73322d7061746368
.section .rodata
.Laot_word_name_127:
  .byte 115
  .byte 50
  .byte 45
  .byte 106
  .byte 117
  .byte 109
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_127:
  .quad .Laot_word_entry_126
  .quad .Laot_word_name_127
  .quad fw_73322d6a756d70
.section .rodata
.Laot_word_name_128:
  .byte 115
  .byte 50
  .byte 45
  .byte 98
  .byte 114
  .byte 97
  .byte 110
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_128:
  .quad .Laot_word_entry_127
  .quad .Laot_word_name_128
  .quad fw_73322d6272616e6368
.section .rodata
.Laot_word_name_129:
  .byte 115
  .byte 50
  .byte 45
  .byte 99
  .byte 111
  .byte 110
  .byte 116
  .byte 114
  .byte 111
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_129:
  .quad .Laot_word_entry_128
  .quad .Laot_word_name_129
  .quad fw_73322d636f6e74726f6c
.section .rodata
.Laot_word_name_130:
  .byte 115
  .byte 50
  .byte 45
  .byte 115
  .byte 116
  .byte 114
  .byte 105
  .byte 110
  .byte 103
  .byte 45
  .byte 108
  .byte 105
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_130:
  .quad .Laot_word_entry_129
  .quad .Laot_word_name_130
  .quad fw_73322d737472696e672d6c6974
.section .rodata
.Laot_word_name_131:
  .byte 115
  .byte 50
  .byte 45
  .byte 116
  .byte 111
  .byte 107
  .byte 101
  .byte 110
  .byte 45
  .byte 101
  .byte 109
  .byte 105
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_131:
  .quad .Laot_word_entry_130
  .quad .Laot_word_name_131
  .quad fw_73322d746f6b656e2d656d6974
.section .rodata
.Laot_word_name_132:
  .byte 115
  .byte 50
  .byte 45
  .byte 99
  .byte 111
  .byte 109
  .byte 112
  .byte 105
  .byte 108
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_132:
  .quad .Laot_word_entry_131
  .quad .Laot_word_name_132
  .quad fw_73322d636f6d70696c65
.section .rodata
.Laot_word_name_133:
  .byte 115
  .byte 50
  .byte 45
  .byte 114
  .byte 101
  .byte 97
  .byte 100
  .byte 45
  .byte 108
  .byte 105
  .byte 110
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_133:
  .quad .Laot_word_entry_132
  .quad .Laot_word_name_133
  .quad fw_73322d726561642d6c696e65
.section .rodata
.Laot_word_name_134:
  .byte 115
  .byte 50
  .byte 45
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_134:
  .quad .Laot_word_entry_133
  .quad .Laot_word_name_134
  .quad fw_73322d736f75726365
.section .rodata
.Laot_word_name_135:
  .byte 115
  .byte 50
  .byte 45
  .byte 101
  .byte 118
  .byte 97
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_135:
  .quad .Laot_word_entry_134
  .quad .Laot_word_name_135
  .quad fw_73322d6576616c
.section .rodata
.Laot_word_name_136:
  .byte 114
  .byte 108
  .byte 45
  .byte 101
  .byte 114
  .byte 97
  .byte 115
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_136:
  .quad .Laot_word_entry_135
  .quad .Laot_word_name_136
  .quad fw_726c2d6572617365
.section .rodata
.Laot_word_name_137:
  .byte 114
  .byte 108
  .byte 45
  .byte 97
  .byte 112
  .byte 112
  .byte 101
  .byte 110
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_137:
  .quad .Laot_word_entry_136
  .quad .Laot_word_name_137
  .quad fw_726c2d617070656e64
.section .rodata
.Laot_word_name_138:
  .byte 114
  .byte 108
  .byte 45
  .byte 114
  .byte 101
  .byte 97
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_138:
  .quad .Laot_word_entry_137
  .quad .Laot_word_name_138
  .quad fw_726c2d72656164
.section .rodata
.Laot_word_name_139:
  .byte 114
  .byte 108
  .byte 45
  .byte 101
  .byte 118
  .byte 97
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_139:
  .quad .Laot_word_entry_138
  .quad .Laot_word_name_139
  .quad fw_726c2d6576616c
.section .rodata
.Laot_word_name_140:
  .byte 114
  .byte 108
  .byte 45
  .byte 109
  .byte 97
  .byte 105
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_140:
  .quad .Laot_word_entry_139
  .quad .Laot_word_name_140
  .quad fw_726c2d6d61696e
.section .rodata
.Laot_word_name_141:
  .byte 117
  .byte 112
  .byte 103
  .byte 114
  .byte 97
  .byte 100
  .byte 101
  .byte 45
  .byte 108
  .byte 111
  .byte 97
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_141:
  .quad .Laot_word_entry_140
  .quad .Laot_word_name_141
  .quad fw_757067726164652d6c6f6164
.section .rodata
.Laot_word_name_142:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 100
  .byte 101
  .byte 99
  .byte 0
.section .data
.Laot_word_entry_142:
  .quad .Laot_word_entry_141
  .quad .Laot_word_name_142
  .quad fw_616f742d646563
.section .rodata
.Laot_word_name_143:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 115
  .byte 105
  .byte 103
  .byte 110
  .byte 101
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_143:
  .quad .Laot_word_entry_142
  .quad .Laot_word_name_143
  .quad fw_616f742d7369676e6564
.section .rodata
.Laot_word_name_144:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 102
  .byte 105
  .byte 116
  .byte 115
  .byte 51
  .byte 50
  .byte 0
.section .data
.Laot_word_entry_144:
  .quad .Laot_word_entry_143
  .quad .Laot_word_name_144
  .quad fw_616f742d666974733332
.section .rodata
.Laot_word_name_145:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 108
  .byte 105
  .byte 116
  .byte 101
  .byte 114
  .byte 97
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_145:
  .quad .Laot_word_entry_144
  .quad .Laot_word_name_145
  .quad fw_616f742d6c69746572616c
.section .rodata
.Laot_word_name_146:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 111
  .byte 112
  .byte 115
  .byte 45
  .byte 111
  .byte 110
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_146:
  .quad .Laot_word_entry_145
  .quad .Laot_word_name_146
  .quad fw_616f742d6f70732d6f6e65
.section .rodata
.Laot_word_name_147:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 111
  .byte 112
  .byte 115
  .byte 45
  .byte 116
  .byte 119
  .byte 111
  .byte 0
.section .data
.Laot_word_entry_147:
  .quad .Laot_word_entry_146
  .quad .Laot_word_name_147
  .quad fw_616f742d6f70732d74776f
.section .rodata
.Laot_word_name_148:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 102
  .byte 105
  .byte 101
  .byte 108
  .byte 100
  .byte 45
  .byte 101
  .byte 113
  .byte 0
.section .data
.Laot_word_entry_148:
  .quad .Laot_word_entry_147
  .quad .Laot_word_name_148
  .quad fw_616f742d6669656c642d6571
.section .rodata
.Laot_word_name_149:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 102
  .byte 105
  .byte 101
  .byte 108
  .byte 100
  .byte 45
  .byte 101
  .byte 110
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_149:
  .quad .Laot_word_entry_148
  .quad .Laot_word_name_149
  .quad fw_616f742d6669656c642d656e64
.section .rodata
.Laot_word_name_150:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 112
  .byte 114
  .byte 105
  .byte 110
  .byte 116
  .byte 45
  .byte 102
  .byte 105
  .byte 101
  .byte 108
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_150:
  .quad .Laot_word_entry_149
  .quad .Laot_word_name_150
  .quad fw_616f742d7072696e742d6669656c64
.section .rodata
.Laot_word_name_151:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 111
  .byte 112
  .byte 45
  .byte 109
  .byte 97
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_151:
  .quad .Laot_word_entry_150
  .quad .Laot_word_name_151
  .quad fw_616f742d6f702d6d6170
.section .rodata
.Laot_word_name_152:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 111
  .byte 112
  .byte 101
  .byte 114
  .byte 97
  .byte 116
  .byte 111
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_152:
  .quad .Laot_word_entry_151
  .quad .Laot_word_name_152
  .quad fw_616f742d6f70657261746f72
.section .rodata
.Laot_word_name_153:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 116
  .byte 111
  .byte 107
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_153:
  .quad .Laot_word_entry_152
  .quad .Laot_word_name_153
  .quad fw_616f742d746f6b656e
.section .rodata
.Laot_word_name_154:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_154:
  .quad .Laot_word_entry_153
  .quad .Laot_word_name_154
  .quad fw_616f742d736f75726365
.section .rodata
.Laot_word_name_155:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 100
  .byte 101
  .byte 109
  .byte 111
  .byte 0
.section .data
.Laot_word_entry_155:
  .quad .Laot_word_entry_154
  .quad .Laot_word_name_155
  .quad fw_616f742d64656d6f
.section .rodata
.Laot_word_name_156:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 110
  .byte 105
  .byte 98
  .byte 98
  .byte 108
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_156:
  .quad .Laot_word_entry_155
  .quad .Laot_word_name_156
  .quad fw_616f742d6e6962626c65
.section .rodata
.Laot_word_name_157:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_157:
  .quad .Laot_word_entry_156
  .quad .Laot_word_name_157
  .quad fw_616f742d6e616d65
.section .rodata
.Laot_word_name_158:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 99
  .byte 97
  .byte 108
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_158:
  .quad .Laot_word_entry_157
  .quad .Laot_word_name_158
  .quad fw_616f742d63616c6c
.section .rodata
.Laot_word_name_159:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 112
  .byte 114
  .byte 111
  .byte 103
  .byte 45
  .byte 116
  .byte 111
  .byte 107
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_159:
  .quad .Laot_word_entry_158
  .quad .Laot_word_name_159
  .quad fw_616f742d70726f672d746f6b656e
.section .rodata
.Laot_word_name_160:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 112
  .byte 114
  .byte 111
  .byte 103
  .byte 114
  .byte 97
  .byte 109
  .byte 0
.section .data
.Laot_word_entry_160:
  .quad .Laot_word_entry_159
  .quad .Laot_word_name_160
  .quad fw_616f742d70726f6772616d
.section .rodata
.Laot_word_name_161:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 112
  .byte 114
  .byte 111
  .byte 103
  .byte 114
  .byte 97
  .byte 109
  .byte 45
  .byte 100
  .byte 101
  .byte 109
  .byte 111
  .byte 0
.section .data
.Laot_word_entry_161:
  .quad .Laot_word_entry_160
  .quad .Laot_word_name_161
  .quad fw_616f742d70726f6772616d2d64656d6f
.section .rodata
.Laot_word_name_162:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_162:
  .quad .Laot_word_entry_161
  .quad .Laot_word_name_162
  .quad fw_616f742d6964
.section .rodata
.Laot_word_name_163:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 108
  .byte 97
  .byte 98
  .byte 101
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_163:
  .quad .Laot_word_entry_162
  .quad .Laot_word_name_163
  .quad fw_616f742d6c6162656c
.section .rodata
.Laot_word_name_164:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 109
  .byte 97
  .byte 114
  .byte 107
  .byte 0
.section .data
.Laot_word_entry_164:
  .quad .Laot_word_entry_163
  .quad .Laot_word_name_164
  .quad fw_616f742d6d61726b
.section .rodata
.Laot_word_name_165:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 106
  .byte 117
  .byte 109
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_165:
  .quad .Laot_word_entry_164
  .quad .Laot_word_name_165
  .quad fw_616f742d6a756d70
.section .rodata
.Laot_word_name_166:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 105
  .byte 102
  .byte 0
.section .data
.Laot_word_entry_166:
  .quad .Laot_word_entry_165
  .quad .Laot_word_name_166
  .quad fw_616f742d6966
.section .rodata
.Laot_word_name_167:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 98
  .byte 101
  .byte 103
  .byte 105
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_167:
  .quad .Laot_word_entry_166
  .quad .Laot_word_name_167
  .quad fw_616f742d626567696e
.section .rodata
.Laot_word_name_168:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 101
  .byte 108
  .byte 115
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_168:
  .quad .Laot_word_entry_167
  .quad .Laot_word_name_168
  .quad fw_616f742d656c7365
.section .rodata
.Laot_word_name_169:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 116
  .byte 104
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_169:
  .quad .Laot_word_entry_168
  .quad .Laot_word_name_169
  .quad fw_616f742d7468656e
.section .rodata
.Laot_word_name_170:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 119
  .byte 104
  .byte 105
  .byte 108
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_170:
  .quad .Laot_word_entry_169
  .quad .Laot_word_name_170
  .quad fw_616f742d7768696c65
.section .rodata
.Laot_word_name_171:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 97
  .byte 103
  .byte 97
  .byte 105
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_171:
  .quad .Laot_word_entry_170
  .quad .Laot_word_name_171
  .quad fw_616f742d616761696e
.section .rodata
.Laot_word_name_172:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 114
  .byte 101
  .byte 112
  .byte 101
  .byte 97
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_172:
  .quad .Laot_word_entry_171
  .quad .Laot_word_name_172
  .quad fw_616f742d726570656174
.section .rodata
.Laot_word_name_173:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 99
  .byte 111
  .byte 110
  .byte 116
  .byte 114
  .byte 111
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_173:
  .quad .Laot_word_entry_172
  .quad .Laot_word_name_173
  .quad fw_616f742d636f6e74726f6c
.section .rodata
.Laot_word_name_174:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 112
  .byte 114
  .byte 111
  .byte 103
  .byte 114
  .byte 97
  .byte 109
  .byte 45
  .byte 119
  .byte 111
  .byte 114
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_174:
  .quad .Laot_word_entry_173
  .quad .Laot_word_name_174
  .quad fw_616f742d70726f6772616d2d776f7264
.section .rodata
.Laot_word_name_175:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 99
  .byte 111
  .byte 110
  .byte 116
  .byte 114
  .byte 111
  .byte 108
  .byte 45
  .byte 100
  .byte 101
  .byte 109
  .byte 111
  .byte 0
.section .data
.Laot_word_entry_175:
  .quad .Laot_word_entry_174
  .quad .Laot_word_name_175
  .quad fw_616f742d636f6e74726f6c2d64656d6f
.section .rodata
.Laot_word_name_176:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 100
  .byte 97
  .byte 116
  .byte 97
  .byte 45
  .byte 98
  .byte 121
  .byte 116
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_176:
  .quad .Laot_word_entry_175
  .quad .Laot_word_name_176
  .quad fw_616f742d646174612d62797465
.section .rodata
.Laot_word_name_177:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 115
  .byte 116
  .byte 114
  .byte 45
  .byte 108
  .byte 97
  .byte 98
  .byte 101
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_177:
  .quad .Laot_word_entry_176
  .quad .Laot_word_name_177
  .quad fw_616f742d7374722d6c6162656c
.section .rodata
.Laot_word_name_178:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 115
  .byte 116
  .byte 114
  .byte 105
  .byte 110
  .byte 103
  .byte 0
.section .data
.Laot_word_entry_178:
  .quad .Laot_word_entry_177
  .quad .Laot_word_name_178
  .quad fw_616f742d737472696e67
.section .rodata
.Laot_word_name_179:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 114
  .byte 101
  .byte 103
  .byte 45
  .byte 101
  .byte 110
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_179:
  .quad .Laot_word_entry_178
  .quad .Laot_word_name_179
  .quad fw_616f742d7265672d656e64
.section .rodata
.Laot_word_name_180:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 114
  .byte 101
  .byte 103
  .byte 45
  .byte 102
  .byte 105
  .byte 110
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_180:
  .quad .Laot_word_entry_179
  .quad .Laot_word_name_180
  .quad fw_616f742d7265672d66696e64
.section .rodata
.Laot_word_name_181:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 114
  .byte 101
  .byte 103
  .byte 45
  .byte 114
  .byte 101
  .byte 109
  .byte 101
  .byte 109
  .byte 98
  .byte 101
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_181:
  .quad .Laot_word_entry_180
  .quad .Laot_word_name_181
  .quad fw_616f742d7265672d72656d656d626572
.section .rodata
.Laot_word_name_182:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 114
  .byte 101
  .byte 103
  .byte 45
  .byte 115
  .byte 99
  .byte 97
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_182:
  .quad .Laot_word_entry_181
  .quad .Laot_word_name_182
  .quad fw_616f742d7265672d7363616e
.section .rodata
.Laot_word_name_183:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 114
  .byte 101
  .byte 103
  .byte 45
  .byte 108
  .byte 97
  .byte 98
  .byte 101
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_183:
  .quad .Laot_word_entry_182
  .quad .Laot_word_name_183
  .quad fw_616f742d7265672d6c6162656c
.section .rodata
.Laot_word_name_184:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 114
  .byte 101
  .byte 103
  .byte 45
  .byte 97
  .byte 100
  .byte 100
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_184:
  .quad .Laot_word_entry_183
  .quad .Laot_word_name_184
  .quad fw_616f742d7265672d61646472
.section .rodata
.Laot_word_name_185:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 114
  .byte 101
  .byte 103
  .byte 45
  .byte 115
  .byte 101
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_185:
  .quad .Laot_word_entry_184
  .quad .Laot_word_name_185
  .quad fw_616f742d7265672d736574
.section .rodata
.Laot_word_name_186:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 114
  .byte 101
  .byte 103
  .byte 45
  .byte 103
  .byte 101
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_186:
  .quad .Laot_word_entry_185
  .quad .Laot_word_name_186
  .quad fw_616f742d7265672d676574
.section .rodata
.Laot_word_name_187:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 115
  .byte 116
  .byte 114
  .byte 105
  .byte 110
  .byte 103
  .byte 45
  .byte 114
  .byte 101
  .byte 103
  .byte 45
  .byte 100
  .byte 101
  .byte 109
  .byte 111
  .byte 0
.section .data
.Laot_word_entry_187:
  .quad .Laot_word_entry_186
  .quad .Laot_word_name_187
  .quad fw_616f742d737472696e672d7265672d64656d6f
.section .rodata
.Laot_word_name_188:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 115
  .byte 107
  .byte 105
  .byte 112
  .byte 45
  .byte 99
  .byte 111
  .byte 109
  .byte 109
  .byte 101
  .byte 110
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_188:
  .quad .Laot_word_entry_187
  .quad .Laot_word_name_188
  .quad fw_616f742d736b69702d636f6d6d656e74
.section .rodata
.Laot_word_name_189:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 110
  .byte 101
  .byte 120
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_189:
  .quad .Laot_word_entry_188
  .quad .Laot_word_name_189
  .quad fw_616f742d6e657874
.section .rodata
.Laot_word_name_190:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 107
  .byte 101
  .byte 114
  .byte 110
  .byte 101
  .byte 108
  .byte 45
  .byte 102
  .byte 114
  .byte 111
  .byte 109
  .byte 45
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_190:
  .quad .Laot_word_entry_189
  .quad .Laot_word_name_190
  .quad fw_616f742d6b65726e656c2d66726f6d2d736f75726365
.section .rodata
.Laot_word_name_191:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 101
  .byte 109
  .byte 105
  .byte 116
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 45
  .byte 98
  .byte 121
  .byte 116
  .byte 101
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_191:
  .quad .Laot_word_entry_190
  .quad .Laot_word_name_191
  .quad fw_616f742d656d69742d6e616d652d6279746573
.section .rodata
.Laot_word_name_192:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 101
  .byte 109
  .byte 105
  .byte 116
  .byte 45
  .byte 102
  .byte 105
  .byte 101
  .byte 108
  .byte 100
  .byte 45
  .byte 98
  .byte 121
  .byte 116
  .byte 101
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_192:
  .quad .Laot_word_entry_191
  .quad .Laot_word_name_192
  .quad fw_616f742d656d69742d6669656c642d6279746573
.section .rodata
.Laot_word_name_193:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 101
  .byte 109
  .byte 105
  .byte 116
  .byte 45
  .byte 102
  .byte 105
  .byte 101
  .byte 108
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_193:
  .quad .Laot_word_entry_192
  .quad .Laot_word_name_193
  .quad fw_616f742d656d69742d6669656c64
.section .rodata
.Laot_word_name_194:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 109
  .byte 101
  .byte 116
  .byte 97
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 45
  .byte 108
  .byte 97
  .byte 98
  .byte 101
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_194:
  .quad .Laot_word_entry_193
  .quad .Laot_word_name_194
  .quad fw_616f742d6d6574612d6e616d652d6c6162656c
.section .rodata
.Laot_word_name_195:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 109
  .byte 101
  .byte 116
  .byte 97
  .byte 45
  .byte 101
  .byte 110
  .byte 116
  .byte 114
  .byte 121
  .byte 45
  .byte 108
  .byte 97
  .byte 98
  .byte 101
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_195:
  .quad .Laot_word_entry_194
  .quad .Laot_word_name_195
  .quad fw_616f742d6d6574612d656e7472792d6c6162656c
.section .rodata
.Laot_word_name_196:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 109
  .byte 101
  .byte 116
  .byte 97
  .byte 45
  .byte 114
  .byte 101
  .byte 102
  .byte 0
.section .data
.Laot_word_entry_196:
  .quad .Laot_word_entry_195
  .quad .Laot_word_name_196
  .quad fw_616f742d6d6574612d726566
.section .rodata
.Laot_word_name_197:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 109
  .byte 101
  .byte 116
  .byte 97
  .byte 45
  .byte 116
  .byte 97
  .byte 98
  .byte 108
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_197:
  .quad .Laot_word_entry_196
  .quad .Laot_word_name_197
  .quad fw_616f742d6d6574612d7461626c65
.section .rodata
.Laot_word_name_198:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 109
  .byte 101
  .byte 116
  .byte 97
  .byte 45
  .byte 100
  .byte 101
  .byte 102
  .byte 105
  .byte 110
  .byte 105
  .byte 116
  .byte 105
  .byte 111
  .byte 110
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_198:
  .quad .Laot_word_entry_197
  .quad .Laot_word_name_198
  .quad fw_616f742d6d6574612d646566696e6974696f6e73
.section .rodata
.Laot_word_name_199:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 109
  .byte 101
  .byte 116
  .byte 97
  .byte 45
  .byte 114
  .byte 101
  .byte 103
  .byte 45
  .byte 115
  .byte 116
  .byte 117
  .byte 98
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_199:
  .quad .Laot_word_entry_198
  .quad .Laot_word_name_199
  .quad fw_616f742d6d6574612d7265672d7374756273
.section .rodata
.Laot_word_name_200:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 109
  .byte 101
  .byte 116
  .byte 97
  .byte 45
  .byte 114
  .byte 101
  .byte 103
  .byte 105
  .byte 115
  .byte 116
  .byte 101
  .byte 114
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_200:
  .quad .Laot_word_entry_199
  .quad .Laot_word_name_200
  .quad fw_616f742d6d6574612d726567697374657273
.section .rodata
.Laot_word_name_201:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 101
  .byte 109
  .byte 105
  .byte 116
  .byte 45
  .byte 107
  .byte 101
  .byte 114
  .byte 110
  .byte 101
  .byte 108
  .byte 45
  .byte 109
  .byte 101
  .byte 116
  .byte 97
  .byte 100
  .byte 97
  .byte 116
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_201:
  .quad .Laot_word_entry_200
  .quad .Laot_word_name_201
  .quad fw_616f742d656d69742d6b65726e656c2d6d65746164617461
.section .rodata
.Laot_word_name_202:
  .byte 98
  .byte 117
  .byte 110
  .byte 100
  .byte 108
  .byte 101
  .byte 45
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_202:
  .quad .Laot_word_entry_201
  .quad .Laot_word_name_202
  .quad fw_62756e646c652d736f75726365
.section .rodata
.Laot_word_name_203:
  .byte 98
  .byte 117
  .byte 110
  .byte 100
  .byte 108
  .byte 101
  .byte 45
  .byte 100
  .byte 101
  .byte 109
  .byte 111
  .byte 0
.section .data
.Laot_word_entry_203:
  .quad .Laot_word_entry_202
  .quad .Laot_word_name_203
  .quad fw_62756e646c652d64656d6f
.section .rodata
.Laot_word_name_204:
  .byte 98
  .byte 117
  .byte 110
  .byte 100
  .byte 108
  .byte 101
  .byte 45
  .byte 107
  .byte 101
  .byte 114
  .byte 110
  .byte 101
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_204:
  .quad .Laot_word_entry_203
  .quad .Laot_word_name_204
  .quad fw_62756e646c652d6b65726e656c
.section .rodata
.Laot_word_name_205:
  .byte 98
  .byte 117
  .byte 110
  .byte 100
  .byte 108
  .byte 101
  .byte 45
  .byte 97
  .byte 112
  .byte 112
  .byte 45
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_205:
  .quad .Laot_word_entry_204
  .quad .Laot_word_name_205
  .quad fw_62756e646c652d6170702d736f75726365
.section .rodata
.Laot_word_name_206:
  .byte 97
  .byte 112
  .byte 112
  .byte 115
  .byte 45
  .byte 114
  .byte 117
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_206:
  .quad .Laot_word_entry_205
  .quad .Laot_word_name_206
  .quad fw_617070732d72756e
.section .rodata
.Laot_word_name_207:
  .byte 97
  .byte 112
  .byte 112
  .byte 115
  .byte 45
  .byte 108
  .byte 111
  .byte 97
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_207:
  .quad .Laot_word_entry_206
  .quad .Laot_word_name_207
  .quad fw_617070732d6c6f6164
.section .rodata
.Laot_word_name_208:
  .byte 97
  .byte 112
  .byte 112
  .byte 115
  .byte 45
  .byte 109
  .byte 101
  .byte 110
  .byte 117
  .byte 0
.section .data
.Laot_word_entry_208:
  .quad .Laot_word_entry_207
  .quad .Laot_word_name_208
  .quad fw_617070732d6d656e75
.section .rodata
.Laot_word_name_209:
  .byte 97
  .byte 112
  .byte 112
  .byte 45
  .byte 114
  .byte 101
  .byte 103
  .byte 105
  .byte 115
  .byte 116
  .byte 101
  .byte 114
  .byte 45
  .byte 115
  .byte 101
  .byte 101
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_209:
  .quad .Laot_word_entry_208
  .quad .Laot_word_name_209
  .quad fw_6170702d72656769737465722d73656564
.section .rodata
.Laot_word_name_210:
  .byte 98
  .byte 97
  .byte 110
  .byte 110
  .byte 101
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_210:
  .quad .Laot_word_entry_209
  .quad .Laot_word_name_210
  .quad fw_62616e6e6572
.section .rodata
.Laot_word_name_211:
  .byte 97
  .byte 100
  .byte 100
  .byte 45
  .byte 116
  .byte 101
  .byte 115
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_211:
  .quad .Laot_word_entry_210
  .quad .Laot_word_name_211
  .quad fw_6164642d74657374
.section .rodata
.Laot_word_name_212:
  .byte 115
  .byte 113
  .byte 117
  .byte 97
  .byte 114
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_212:
  .quad .Laot_word_entry_211
  .quad .Laot_word_name_212
  .quad fw_737175617265
.section .rodata
.Laot_word_name_213:
  .byte 98
  .byte 114
  .byte 97
  .byte 110
  .byte 99
  .byte 104
  .byte 45
  .byte 116
  .byte 101
  .byte 115
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_213:
  .quad .Laot_word_entry_212
  .quad .Laot_word_name_213
  .quad fw_6272616e63682d74657374
.section .rodata
.Laot_word_name_214:
  .byte 108
  .byte 111
  .byte 111
  .byte 112
  .byte 45
  .byte 116
  .byte 101
  .byte 115
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_214:
  .quad .Laot_word_entry_213
  .quad .Laot_word_name_214
  .quad fw_6c6f6f702d74657374
.section .rodata
.Laot_word_name_215:
  .byte 100
  .byte 114
  .byte 97
  .byte 119
  .byte 45
  .byte 100
  .byte 101
  .byte 109
  .byte 111
  .byte 0
.section .data
.Laot_word_entry_215:
  .quad .Laot_word_entry_214
  .quad .Laot_word_name_215
  .quad fw_647261772d64656d6f
.section .rodata
.Laot_word_name_216:
  .byte 104
  .byte 97
  .byte 114
  .byte 100
  .byte 119
  .byte 97
  .byte 114
  .byte 101
  .byte 63
  .byte 0
.section .data
.Laot_word_entry_216:
  .quad .Laot_word_entry_215
  .quad .Laot_word_name_216
  .quad fw_68617264776172653f
.section .rodata
.Laot_word_name_217:
  .byte 100
  .byte 105
  .byte 115
  .byte 107
  .byte 45
  .byte 114
  .byte 101
  .byte 97
  .byte 100
  .byte 121
  .byte 63
  .byte 0
.section .data
.Laot_word_entry_217:
  .quad .Laot_word_entry_216
  .quad .Laot_word_name_217
  .quad fw_6469736b2d72656164793f
.section .rodata
.Laot_word_name_218:
  .byte 100
  .byte 105
  .byte 115
  .byte 107
  .byte 45
  .byte 102
  .byte 111
  .byte 114
  .byte 109
  .byte 97
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_218:
  .quad .Laot_word_entry_217
  .quad .Laot_word_name_218
  .quad fw_6469736b2d666f726d6174
.section .rodata
.Laot_word_name_219:
  .byte 104
  .byte 111
  .byte 115
  .byte 116
  .byte 45
  .byte 115
  .byte 97
  .byte 118
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_219:
  .quad .Laot_word_entry_218
  .quad .Laot_word_name_219
  .quad fw_686f73742d73617665
.section .rodata
.Laot_word_name_220:
  .byte 104
  .byte 111
  .byte 115
  .byte 116
  .byte 45
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_220:
  .quad .Laot_word_entry_219
  .quad .Laot_word_name_220
  .quad fw_686f73742d736f75726365
.section .rodata
.Laot_word_name_221:
  .byte 104
  .byte 111
  .byte 115
  .byte 116
  .byte 45
  .byte 102
  .byte 105
  .byte 108
  .byte 101
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_221:
  .quad .Laot_word_entry_220
  .quad .Laot_word_name_221
  .quad fw_686f73742d66696c6573
.section .rodata
.Laot_word_name_222:
  .byte 104
  .byte 111
  .byte 115
  .byte 116
  .byte 45
  .byte 107
  .byte 101
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_222:
  .quad .Laot_word_entry_221
  .quad .Laot_word_name_222
  .quad fw_686f73742d6b6579
.section .rodata
.Laot_word_name_223:
  .byte 115
  .byte 116
  .byte 111
  .byte 114
  .byte 101
  .byte 45
  .byte 99
  .byte 104
  .byte 101
  .byte 99
  .byte 107
  .byte 0
.section .data
.Laot_word_entry_223:
  .quad .Laot_word_entry_222
  .quad .Laot_word_name_223
  .quad fw_73746f72652d636865636b
.section .rodata
.Laot_word_name_224:
  .byte 97
  .byte 116
  .byte 97
  .byte 45
  .byte 99
  .byte 104
  .byte 101
  .byte 99
  .byte 107
  .byte 0
.section .data
.Laot_word_entry_224:
  .quad .Laot_word_entry_223
  .quad .Laot_word_name_224
  .quad fw_6174612d636865636b
.section .rodata
.Laot_word_name_225:
  .byte 99
  .byte 111
  .byte 110
  .byte 115
  .byte 111
  .byte 108
  .byte 101
  .byte 45
  .byte 104
  .byte 101
  .byte 108
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_225:
  .quad .Laot_word_entry_224
  .quad .Laot_word_name_225
  .quad fw_636f6e736f6c652d68656c70
.section .rodata
.Laot_word_name_226:
  .byte 99
  .byte 111
  .byte 110
  .byte 115
  .byte 111
  .byte 108
  .byte 101
  .byte 45
  .byte 109
  .byte 97
  .byte 105
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_226:
  .quad .Laot_word_entry_225
  .quad .Laot_word_name_226
  .quad fw_636f6e736f6c652d6d61696e
.section .rodata
.Laot_word_name_227:
  .byte 99
  .byte 111
  .byte 109
  .byte 112
  .byte 105
  .byte 108
  .byte 101
  .byte 114
  .byte 45
  .byte 98
  .byte 111
  .byte 111
  .byte 116
  .byte 115
  .byte 116
  .byte 114
  .byte 97
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_227:
  .quad .Laot_word_entry_226
  .quad .Laot_word_name_227
  .quad fw_636f6d70696c65722d626f6f747374726170
.section .rodata
.Laot_word_name_228:
  .byte 99
  .byte 111
  .byte 109
  .byte 112
  .byte 105
  .byte 108
  .byte 101
  .byte 114
  .byte 45
  .byte 112
  .byte 114
  .byte 111
  .byte 98
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_228:
  .quad .Laot_word_entry_227
  .quad .Laot_word_name_228
  .quad fw_636f6d70696c65722d70726f6265
.section .rodata
.Laot_word_name_229:
  .byte 98
  .byte 111
  .byte 111
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_229:
  .quad .Laot_word_entry_228
  .quad .Laot_word_name_229
  .quad fw_626f6f74
.section .text
aot_get_fw_61742d636f756e74:
  leaq reg_fw_61742d636f756e74(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61742d636f756e74:
  leaq reg_fw_61742d636f756e74(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_230:
  .byte 97
  .byte 116
  .byte 45
  .byte 99
  .byte 111
  .byte 117
  .byte 110
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_230:
  .quad .Laot_word_entry_229
  .quad .Laot_word_name_230
  .quad aot_get_fw_61742d636f756e74
.section .rodata
.Laot_word_name_231:
  .byte 58
  .byte 97
  .byte 116
  .byte 45
  .byte 99
  .byte 111
  .byte 117
  .byte 110
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_231:
  .quad .Laot_word_entry_230
  .quad .Laot_word_name_231
  .quad aot_set_fw_61742d636f756e74
.section .text
aot_get_fw_61742d69:
  leaq reg_fw_61742d69(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61742d69:
  leaq reg_fw_61742d69(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_232:
  .byte 97
  .byte 116
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_232:
  .quad .Laot_word_entry_231
  .quad .Laot_word_name_232
  .quad aot_get_fw_61742d69
.section .rodata
.Laot_word_name_233:
  .byte 58
  .byte 97
  .byte 116
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_233:
  .quad .Laot_word_entry_232
  .quad .Laot_word_name_233
  .quad aot_set_fw_61742d69
.section .text
aot_get_fw_61742d737461747573:
  leaq reg_fw_61742d737461747573(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61742d737461747573:
  leaq reg_fw_61742d737461747573(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_234:
  .byte 97
  .byte 116
  .byte 45
  .byte 115
  .byte 116
  .byte 97
  .byte 116
  .byte 117
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_234:
  .quad .Laot_word_entry_233
  .quad .Laot_word_name_234
  .quad aot_get_fw_61742d737461747573
.section .rodata
.Laot_word_name_235:
  .byte 58
  .byte 97
  .byte 116
  .byte 45
  .byte 115
  .byte 116
  .byte 97
  .byte 116
  .byte 117
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_235:
  .quad .Laot_word_entry_234
  .quad .Laot_word_name_235
  .quad aot_set_fw_61742d737461747573
.section .text
aot_get_fw_61742d6c6261:
  leaq reg_fw_61742d6c6261(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61742d6c6261:
  leaq reg_fw_61742d6c6261(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_236:
  .byte 97
  .byte 116
  .byte 45
  .byte 108
  .byte 98
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_236:
  .quad .Laot_word_entry_235
  .quad .Laot_word_name_236
  .quad aot_get_fw_61742d6c6261
.section .rodata
.Laot_word_name_237:
  .byte 58
  .byte 97
  .byte 116
  .byte 45
  .byte 108
  .byte 98
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_237:
  .quad .Laot_word_entry_236
  .quad .Laot_word_name_237
  .quad aot_set_fw_61742d6c6261
.section .text
aot_get_fw_61742d626f756e6473:
  leaq reg_fw_61742d626f756e6473(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61742d626f756e6473:
  leaq reg_fw_61742d626f756e6473(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_238:
  .byte 97
  .byte 116
  .byte 45
  .byte 98
  .byte 111
  .byte 117
  .byte 110
  .byte 100
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_238:
  .quad .Laot_word_entry_237
  .quad .Laot_word_name_238
  .quad aot_get_fw_61742d626f756e6473
.section .rodata
.Laot_word_name_239:
  .byte 58
  .byte 97
  .byte 116
  .byte 45
  .byte 98
  .byte 111
  .byte 117
  .byte 110
  .byte 100
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_239:
  .quad .Laot_word_entry_238
  .quad .Laot_word_name_239
  .quad aot_set_fw_61742d626f756e6473
.section .text
aot_get_fw_61742d776f7264:
  leaq reg_fw_61742d776f7264(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61742d776f7264:
  leaq reg_fw_61742d776f7264(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_240:
  .byte 97
  .byte 116
  .byte 45
  .byte 119
  .byte 111
  .byte 114
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_240:
  .quad .Laot_word_entry_239
  .quad .Laot_word_name_240
  .quad aot_get_fw_61742d776f7264
.section .rodata
.Laot_word_name_241:
  .byte 58
  .byte 97
  .byte 116
  .byte 45
  .byte 119
  .byte 111
  .byte 114
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_241:
  .quad .Laot_word_entry_240
  .quad .Laot_word_name_241
  .quad aot_set_fw_61742d776f7264
.section .text
aot_get_fw_61722d69:
  leaq reg_fw_61722d69(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61722d69:
  leaq reg_fw_61722d69(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_242:
  .byte 97
  .byte 114
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_242:
  .quad .Laot_word_entry_241
  .quad .Laot_word_name_242
  .quad aot_get_fw_61722d69
.section .rodata
.Laot_word_name_243:
  .byte 58
  .byte 97
  .byte 114
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_243:
  .quad .Laot_word_entry_242
  .quad .Laot_word_name_243
  .quad aot_set_fw_61722d69
.section .text
aot_get_fw_61722d737461747573:
  leaq reg_fw_61722d737461747573(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61722d737461747573:
  leaq reg_fw_61722d737461747573(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_244:
  .byte 97
  .byte 114
  .byte 45
  .byte 115
  .byte 116
  .byte 97
  .byte 116
  .byte 117
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_244:
  .quad .Laot_word_entry_243
  .quad .Laot_word_name_244
  .quad aot_get_fw_61722d737461747573
.section .rodata
.Laot_word_name_245:
  .byte 58
  .byte 97
  .byte 114
  .byte 45
  .byte 115
  .byte 116
  .byte 97
  .byte 116
  .byte 117
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_245:
  .quad .Laot_word_entry_244
  .quad .Laot_word_name_245
  .quad aot_set_fw_61722d737461747573
.section .text
aot_get_fw_61772d6c6261:
  leaq reg_fw_61772d6c6261(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61772d6c6261:
  leaq reg_fw_61772d6c6261(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_246:
  .byte 97
  .byte 119
  .byte 45
  .byte 108
  .byte 98
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_246:
  .quad .Laot_word_entry_245
  .quad .Laot_word_name_246
  .quad aot_get_fw_61772d6c6261
.section .rodata
.Laot_word_name_247:
  .byte 58
  .byte 97
  .byte 119
  .byte 45
  .byte 108
  .byte 98
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_247:
  .quad .Laot_word_entry_246
  .quad .Laot_word_name_247
  .quad aot_set_fw_61772d6c6261
.section .text
aot_get_fw_61772d76616c6964:
  leaq reg_fw_61772d76616c6964(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61772d76616c6964:
  leaq reg_fw_61772d76616c6964(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_248:
  .byte 97
  .byte 119
  .byte 45
  .byte 118
  .byte 97
  .byte 108
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_248:
  .quad .Laot_word_entry_247
  .quad .Laot_word_name_248
  .quad aot_get_fw_61772d76616c6964
.section .rodata
.Laot_word_name_249:
  .byte 58
  .byte 97
  .byte 119
  .byte 45
  .byte 118
  .byte 97
  .byte 108
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_249:
  .quad .Laot_word_entry_248
  .quad .Laot_word_name_249
  .quad aot_set_fw_61772d76616c6964
.section .text
aot_get_fw_61772d69:
  leaq reg_fw_61772d69(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61772d69:
  leaq reg_fw_61772d69(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_250:
  .byte 97
  .byte 119
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_250:
  .quad .Laot_word_entry_249
  .quad .Laot_word_name_250
  .quad aot_get_fw_61772d69
.section .rodata
.Laot_word_name_251:
  .byte 58
  .byte 97
  .byte 119
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_251:
  .quad .Laot_word_entry_250
  .quad .Laot_word_name_251
  .quad aot_set_fw_61772d69
.section .text
aot_get_fw_61772d776f7264:
  leaq reg_fw_61772d776f7264(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61772d776f7264:
  leaq reg_fw_61772d776f7264(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_252:
  .byte 97
  .byte 119
  .byte 45
  .byte 119
  .byte 111
  .byte 114
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_252:
  .quad .Laot_word_entry_251
  .quad .Laot_word_name_252
  .quad aot_get_fw_61772d776f7264
.section .rodata
.Laot_word_name_253:
  .byte 58
  .byte 97
  .byte 119
  .byte 45
  .byte 119
  .byte 111
  .byte 114
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_253:
  .quad .Laot_word_entry_252
  .quad .Laot_word_name_253
  .quad aot_set_fw_61772d776f7264
.section .text
aot_get_fw_666c2d61646472:
  leaq reg_fw_666c2d61646472(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_666c2d61646472:
  leaq reg_fw_666c2d61646472(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_254:
  .byte 102
  .byte 108
  .byte 45
  .byte 97
  .byte 100
  .byte 100
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_254:
  .quad .Laot_word_entry_253
  .quad .Laot_word_name_254
  .quad aot_get_fw_666c2d61646472
.section .rodata
.Laot_word_name_255:
  .byte 58
  .byte 102
  .byte 108
  .byte 45
  .byte 97
  .byte 100
  .byte 100
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_255:
  .quad .Laot_word_entry_254
  .quad .Laot_word_name_255
  .quad aot_set_fw_666c2d61646472
.section .text
aot_get_fw_666c2d6e:
  leaq reg_fw_666c2d6e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_666c2d6e:
  leaq reg_fw_666c2d6e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_256:
  .byte 102
  .byte 108
  .byte 45
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_256:
  .quad .Laot_word_entry_255
  .quad .Laot_word_name_256
  .quad aot_get_fw_666c2d6e
.section .rodata
.Laot_word_name_257:
  .byte 58
  .byte 102
  .byte 108
  .byte 45
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_257:
  .quad .Laot_word_entry_256
  .quad .Laot_word_name_257
  .quad aot_set_fw_666c2d6e
.section .text
aot_get_fw_667a2d69:
  leaq reg_fw_667a2d69(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_667a2d69:
  leaq reg_fw_667a2d69(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_258:
  .byte 102
  .byte 122
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_258:
  .quad .Laot_word_entry_257
  .quad .Laot_word_name_258
  .quad aot_get_fw_667a2d69
.section .rodata
.Laot_word_name_259:
  .byte 58
  .byte 102
  .byte 122
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_259:
  .quad .Laot_word_entry_258
  .quad .Laot_word_name_259
  .quad aot_set_fw_667a2d69
.section .text
aot_get_fw_666d2d69:
  leaq reg_fw_666d2d69(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_666d2d69:
  leaq reg_fw_666d2d69(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_260:
  .byte 102
  .byte 109
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_260:
  .quad .Laot_word_entry_259
  .quad .Laot_word_name_260
  .quad aot_get_fw_666d2d69
.section .rodata
.Laot_word_name_261:
  .byte 58
  .byte 102
  .byte 109
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_261:
  .quad .Laot_word_entry_260
  .quad .Laot_word_name_261
  .quad aot_set_fw_666d2d69
.section .text
aot_get_fw_666e2d736c6f74:
  leaq reg_fw_666e2d736c6f74(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_666e2d736c6f74:
  leaq reg_fw_666e2d736c6f74(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_262:
  .byte 102
  .byte 110
  .byte 45
  .byte 115
  .byte 108
  .byte 111
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_262:
  .quad .Laot_word_entry_261
  .quad .Laot_word_name_262
  .quad aot_get_fw_666e2d736c6f74
.section .rodata
.Laot_word_name_263:
  .byte 58
  .byte 102
  .byte 110
  .byte 45
  .byte 115
  .byte 108
  .byte 111
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_263:
  .quad .Laot_word_entry_262
  .quad .Laot_word_name_263
  .quad aot_set_fw_666e2d736c6f74
.section .text
aot_get_fw_666e2d6e616d65:
  leaq reg_fw_666e2d6e616d65(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_666e2d6e616d65:
  leaq reg_fw_666e2d6e616d65(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_264:
  .byte 102
  .byte 110
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_264:
  .quad .Laot_word_entry_263
  .quad .Laot_word_name_264
  .quad aot_get_fw_666e2d6e616d65
.section .rodata
.Laot_word_name_265:
  .byte 58
  .byte 102
  .byte 110
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_265:
  .quad .Laot_word_entry_264
  .quad .Laot_word_name_265
  .quad aot_set_fw_666e2d6e616d65
.section .text
aot_get_fw_666e2d62617365:
  leaq reg_fw_666e2d62617365(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_666e2d62617365:
  leaq reg_fw_666e2d62617365(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_266:
  .byte 102
  .byte 110
  .byte 45
  .byte 98
  .byte 97
  .byte 115
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_266:
  .quad .Laot_word_entry_265
  .quad .Laot_word_name_266
  .quad aot_get_fw_666e2d62617365
.section .rodata
.Laot_word_name_267:
  .byte 58
  .byte 102
  .byte 110
  .byte 45
  .byte 98
  .byte 97
  .byte 115
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_267:
  .quad .Laot_word_entry_266
  .quad .Laot_word_name_267
  .quad aot_set_fw_666e2d62617365
.section .text
aot_get_fw_666e2d69:
  leaq reg_fw_666e2d69(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_666e2d69:
  leaq reg_fw_666e2d69(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_268:
  .byte 102
  .byte 110
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_268:
  .quad .Laot_word_entry_267
  .quad .Laot_word_name_268
  .quad aot_get_fw_666e2d69
.section .rodata
.Laot_word_name_269:
  .byte 58
  .byte 102
  .byte 110
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_269:
  .quad .Laot_word_entry_268
  .quad .Laot_word_name_269
  .quad aot_set_fw_666e2d69
.section .text
aot_get_fw_666e2d63:
  leaq reg_fw_666e2d63(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_666e2d63:
  leaq reg_fw_666e2d63(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_270:
  .byte 102
  .byte 110
  .byte 45
  .byte 99
  .byte 0
.section .data
.Laot_word_entry_270:
  .quad .Laot_word_entry_269
  .quad .Laot_word_name_270
  .quad aot_get_fw_666e2d63
.section .rodata
.Laot_word_name_271:
  .byte 58
  .byte 102
  .byte 110
  .byte 45
  .byte 99
  .byte 0
.section .data
.Laot_word_entry_271:
  .quad .Laot_word_entry_270
  .quad .Laot_word_name_271
  .quad aot_set_fw_666e2d63
.section .text
aot_get_fw_666e2d64:
  leaq reg_fw_666e2d64(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_666e2d64:
  leaq reg_fw_666e2d64(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_272:
  .byte 102
  .byte 110
  .byte 45
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_272:
  .quad .Laot_word_entry_271
  .quad .Laot_word_name_272
  .quad aot_get_fw_666e2d64
.section .rodata
.Laot_word_name_273:
  .byte 58
  .byte 102
  .byte 110
  .byte 45
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_273:
  .quad .Laot_word_entry_272
  .quad .Laot_word_name_273
  .quad aot_set_fw_666e2d64
.section .text
aot_get_fw_66662d6e616d65:
  leaq reg_fw_66662d6e616d65(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_66662d6e616d65:
  leaq reg_fw_66662d6e616d65(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_274:
  .byte 102
  .byte 102
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_274:
  .quad .Laot_word_entry_273
  .quad .Laot_word_name_274
  .quad aot_get_fw_66662d6e616d65
.section .rodata
.Laot_word_name_275:
  .byte 58
  .byte 102
  .byte 102
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_275:
  .quad .Laot_word_entry_274
  .quad .Laot_word_name_275
  .quad aot_set_fw_66662d6e616d65
.section .text
aot_get_fw_66662d69:
  leaq reg_fw_66662d69(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_66662d69:
  leaq reg_fw_66662d69(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_276:
  .byte 102
  .byte 102
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_276:
  .quad .Laot_word_entry_275
  .quad .Laot_word_name_276
  .quad aot_get_fw_66662d69
.section .rodata
.Laot_word_name_277:
  .byte 58
  .byte 102
  .byte 102
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_277:
  .quad .Laot_word_entry_276
  .quad .Laot_word_name_277
  .quad aot_set_fw_66662d69
.section .text
aot_get_fw_66652d69:
  leaq reg_fw_66652d69(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_66652d69:
  leaq reg_fw_66652d69(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_278:
  .byte 102
  .byte 101
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_278:
  .quad .Laot_word_entry_277
  .quad .Laot_word_name_278
  .quad aot_get_fw_66652d69
.section .rodata
.Laot_word_name_279:
  .byte 58
  .byte 102
  .byte 101
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_279:
  .quad .Laot_word_entry_278
  .quad .Laot_word_name_279
  .quad aot_set_fw_66652d69
.section .text
aot_get_fw_66732d64617461:
  leaq reg_fw_66732d64617461(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_66732d64617461:
  leaq reg_fw_66732d64617461(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_280:
  .byte 102
  .byte 115
  .byte 45
  .byte 100
  .byte 97
  .byte 116
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_280:
  .quad .Laot_word_entry_279
  .quad .Laot_word_name_280
  .quad aot_get_fw_66732d64617461
.section .rodata
.Laot_word_name_281:
  .byte 58
  .byte 102
  .byte 115
  .byte 45
  .byte 100
  .byte 97
  .byte 116
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_281:
  .quad .Laot_word_entry_280
  .quad .Laot_word_name_281
  .quad aot_set_fw_66732d64617461
.section .text
aot_get_fw_66732d6e616d65:
  leaq reg_fw_66732d6e616d65(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_66732d6e616d65:
  leaq reg_fw_66732d6e616d65(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_282:
  .byte 102
  .byte 115
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_282:
  .quad .Laot_word_entry_281
  .quad .Laot_word_name_282
  .quad aot_get_fw_66732d6e616d65
.section .rodata
.Laot_word_name_283:
  .byte 58
  .byte 102
  .byte 115
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_283:
  .quad .Laot_word_entry_282
  .quad .Laot_word_name_283
  .quad aot_set_fw_66732d6e616d65
.section .text
aot_get_fw_66732d6e6c656e:
  leaq reg_fw_66732d6e6c656e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_66732d6e6c656e:
  leaq reg_fw_66732d6e6c656e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_284:
  .byte 102
  .byte 115
  .byte 45
  .byte 110
  .byte 108
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_284:
  .quad .Laot_word_entry_283
  .quad .Laot_word_name_284
  .quad aot_get_fw_66732d6e6c656e
.section .rodata
.Laot_word_name_285:
  .byte 58
  .byte 102
  .byte 115
  .byte 45
  .byte 110
  .byte 108
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_285:
  .quad .Laot_word_entry_284
  .quad .Laot_word_name_285
  .quad aot_set_fw_66732d6e6c656e
.section .text
aot_get_fw_66732d646c656e:
  leaq reg_fw_66732d646c656e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_66732d646c656e:
  leaq reg_fw_66732d646c656e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_286:
  .byte 102
  .byte 115
  .byte 45
  .byte 100
  .byte 108
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_286:
  .quad .Laot_word_entry_285
  .quad .Laot_word_name_286
  .quad aot_get_fw_66732d646c656e
.section .rodata
.Laot_word_name_287:
  .byte 58
  .byte 102
  .byte 115
  .byte 45
  .byte 100
  .byte 108
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_287:
  .quad .Laot_word_entry_286
  .quad .Laot_word_name_287
  .quad aot_set_fw_66732d646c656e
.section .text
aot_get_fw_66732d6e2d6f6b:
  leaq reg_fw_66732d6e2d6f6b(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_66732d6e2d6f6b:
  leaq reg_fw_66732d6e2d6f6b(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_288:
  .byte 102
  .byte 115
  .byte 45
  .byte 110
  .byte 45
  .byte 111
  .byte 107
  .byte 0
.section .data
.Laot_word_entry_288:
  .quad .Laot_word_entry_287
  .quad .Laot_word_name_288
  .quad aot_get_fw_66732d6e2d6f6b
.section .rodata
.Laot_word_name_289:
  .byte 58
  .byte 102
  .byte 115
  .byte 45
  .byte 110
  .byte 45
  .byte 111
  .byte 107
  .byte 0
.section .data
.Laot_word_entry_289:
  .quad .Laot_word_entry_288
  .quad .Laot_word_name_289
  .quad aot_set_fw_66732d6e2d6f6b
.section .text
aot_get_fw_66732d736c6f74:
  leaq reg_fw_66732d736c6f74(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_66732d736c6f74:
  leaq reg_fw_66732d736c6f74(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_290:
  .byte 102
  .byte 115
  .byte 45
  .byte 115
  .byte 108
  .byte 111
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_290:
  .quad .Laot_word_entry_289
  .quad .Laot_word_name_290
  .quad aot_get_fw_66732d736c6f74
.section .rodata
.Laot_word_name_291:
  .byte 58
  .byte 102
  .byte 115
  .byte 45
  .byte 115
  .byte 108
  .byte 111
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_291:
  .quad .Laot_word_entry_290
  .quad .Laot_word_name_291
  .quad aot_set_fw_66732d736c6f74
.section .text
aot_get_fw_66732d626c6f636b:
  leaq reg_fw_66732d626c6f636b(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_66732d626c6f636b:
  leaq reg_fw_66732d626c6f636b(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_292:
  .byte 102
  .byte 115
  .byte 45
  .byte 98
  .byte 108
  .byte 111
  .byte 99
  .byte 107
  .byte 0
.section .data
.Laot_word_entry_292:
  .quad .Laot_word_entry_291
  .quad .Laot_word_name_292
  .quad aot_get_fw_66732d626c6f636b
.section .rodata
.Laot_word_name_293:
  .byte 58
  .byte 102
  .byte 115
  .byte 45
  .byte 98
  .byte 108
  .byte 111
  .byte 99
  .byte 107
  .byte 0
.section .data
.Laot_word_entry_293:
  .quad .Laot_word_entry_292
  .quad .Laot_word_name_293
  .quad aot_set_fw_66732d626c6f636b
.section .text
aot_get_fw_66732d6a:
  leaq reg_fw_66732d6a(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_66732d6a:
  leaq reg_fw_66732d6a(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_294:
  .byte 102
  .byte 115
  .byte 45
  .byte 106
  .byte 0
.section .data
.Laot_word_entry_294:
  .quad .Laot_word_entry_293
  .quad .Laot_word_name_294
  .quad aot_get_fw_66732d6a
.section .rodata
.Laot_word_name_295:
  .byte 58
  .byte 102
  .byte 115
  .byte 45
  .byte 106
  .byte 0
.section .data
.Laot_word_entry_295:
  .quad .Laot_word_entry_294
  .quad .Laot_word_name_295
  .quad aot_set_fw_66732d6a
.section .text
aot_get_fw_66732d696e646578:
  leaq reg_fw_66732d696e646578(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_66732d696e646578:
  leaq reg_fw_66732d696e646578(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_296:
  .byte 102
  .byte 115
  .byte 45
  .byte 105
  .byte 110
  .byte 100
  .byte 101
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_296:
  .quad .Laot_word_entry_295
  .quad .Laot_word_name_296
  .quad aot_get_fw_66732d696e646578
.section .rodata
.Laot_word_name_297:
  .byte 58
  .byte 102
  .byte 115
  .byte 45
  .byte 105
  .byte 110
  .byte 100
  .byte 101
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_297:
  .quad .Laot_word_entry_296
  .quad .Laot_word_name_297
  .quad aot_set_fw_66732d696e646578
.section .text
aot_get_fw_66732d62617365:
  leaq reg_fw_66732d62617365(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_66732d62617365:
  leaq reg_fw_66732d62617365(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_298:
  .byte 102
  .byte 115
  .byte 45
  .byte 98
  .byte 97
  .byte 115
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_298:
  .quad .Laot_word_entry_297
  .quad .Laot_word_name_298
  .quad aot_get_fw_66732d62617365
.section .rodata
.Laot_word_name_299:
  .byte 58
  .byte 102
  .byte 115
  .byte 45
  .byte 98
  .byte 97
  .byte 115
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_299:
  .quad .Laot_word_entry_298
  .quad .Laot_word_name_299
  .quad aot_set_fw_66732d62617365
.section .text
aot_get_fw_6673722d6e616d65:
  leaq reg_fw_6673722d6e616d65(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6673722d6e616d65:
  leaq reg_fw_6673722d6e616d65(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_300:
  .byte 102
  .byte 115
  .byte 114
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_300:
  .quad .Laot_word_entry_299
  .quad .Laot_word_name_300
  .quad aot_get_fw_6673722d6e616d65
.section .rodata
.Laot_word_name_301:
  .byte 58
  .byte 102
  .byte 115
  .byte 114
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_301:
  .quad .Laot_word_entry_300
  .quad .Laot_word_name_301
  .quad aot_set_fw_6673722d6e616d65
.section .text
aot_get_fw_6673722d736c6f74:
  leaq reg_fw_6673722d736c6f74(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6673722d736c6f74:
  leaq reg_fw_6673722d736c6f74(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_302:
  .byte 102
  .byte 115
  .byte 114
  .byte 45
  .byte 115
  .byte 108
  .byte 111
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_302:
  .quad .Laot_word_entry_301
  .quad .Laot_word_name_302
  .quad aot_get_fw_6673722d736c6f74
.section .rodata
.Laot_word_name_303:
  .byte 58
  .byte 102
  .byte 115
  .byte 114
  .byte 45
  .byte 115
  .byte 108
  .byte 111
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_303:
  .quad .Laot_word_entry_302
  .quad .Laot_word_name_303
  .quad aot_set_fw_6673722d736c6f74
.section .text
aot_get_fw_6673722d6c6f:
  leaq reg_fw_6673722d6c6f(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6673722d6c6f:
  leaq reg_fw_6673722d6c6f(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_304:
  .byte 102
  .byte 115
  .byte 114
  .byte 45
  .byte 108
  .byte 111
  .byte 0
.section .data
.Laot_word_entry_304:
  .quad .Laot_word_entry_303
  .quad .Laot_word_name_304
  .quad aot_get_fw_6673722d6c6f
.section .rodata
.Laot_word_name_305:
  .byte 58
  .byte 102
  .byte 115
  .byte 114
  .byte 45
  .byte 108
  .byte 111
  .byte 0
.section .data
.Laot_word_entry_305:
  .quad .Laot_word_entry_304
  .quad .Laot_word_name_305
  .quad aot_set_fw_6673722d6c6f
.section .text
aot_get_fw_6673722d6c656e677468:
  leaq reg_fw_6673722d6c656e677468(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6673722d6c656e677468:
  leaq reg_fw_6673722d6c656e677468(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_306:
  .byte 102
  .byte 115
  .byte 114
  .byte 45
  .byte 108
  .byte 101
  .byte 110
  .byte 103
  .byte 116
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_306:
  .quad .Laot_word_entry_305
  .quad .Laot_word_name_306
  .quad aot_get_fw_6673722d6c656e677468
.section .rodata
.Laot_word_name_307:
  .byte 58
  .byte 102
  .byte 115
  .byte 114
  .byte 45
  .byte 108
  .byte 101
  .byte 110
  .byte 103
  .byte 116
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_307:
  .quad .Laot_word_entry_306
  .quad .Laot_word_name_307
  .quad aot_set_fw_6673722d6c656e677468
.section .text
aot_get_fw_6673722d746f6f2d6c6f6e67:
  leaq reg_fw_6673722d746f6f2d6c6f6e67(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6673722d746f6f2d6c6f6e67:
  leaq reg_fw_6673722d746f6f2d6c6f6e67(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_308:
  .byte 102
  .byte 115
  .byte 114
  .byte 45
  .byte 116
  .byte 111
  .byte 111
  .byte 45
  .byte 108
  .byte 111
  .byte 110
  .byte 103
  .byte 0
.section .data
.Laot_word_entry_308:
  .quad .Laot_word_entry_307
  .quad .Laot_word_name_308
  .quad aot_get_fw_6673722d746f6f2d6c6f6e67
.section .rodata
.Laot_word_name_309:
  .byte 58
  .byte 102
  .byte 115
  .byte 114
  .byte 45
  .byte 116
  .byte 111
  .byte 111
  .byte 45
  .byte 108
  .byte 111
  .byte 110
  .byte 103
  .byte 0
.section .data
.Laot_word_entry_309:
  .quad .Laot_word_entry_308
  .quad .Laot_word_name_309
  .quad aot_set_fw_6673722d746f6f2d6c6f6e67
.section .text
aot_get_fw_6673722d626c6f636b:
  leaq reg_fw_6673722d626c6f636b(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6673722d626c6f636b:
  leaq reg_fw_6673722d626c6f636b(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_310:
  .byte 102
  .byte 115
  .byte 114
  .byte 45
  .byte 98
  .byte 108
  .byte 111
  .byte 99
  .byte 107
  .byte 0
.section .data
.Laot_word_entry_310:
  .quad .Laot_word_entry_309
  .quad .Laot_word_name_310
  .quad aot_get_fw_6673722d626c6f636b
.section .rodata
.Laot_word_name_311:
  .byte 58
  .byte 102
  .byte 115
  .byte 114
  .byte 45
  .byte 98
  .byte 108
  .byte 111
  .byte 99
  .byte 107
  .byte 0
.section .data
.Laot_word_entry_311:
  .quad .Laot_word_entry_310
  .quad .Laot_word_name_311
  .quad aot_set_fw_6673722d626c6f636b
.section .text
aot_get_fw_6673722d69:
  leaq reg_fw_6673722d69(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6673722d69:
  leaq reg_fw_6673722d69(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_312:
  .byte 102
  .byte 115
  .byte 114
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_312:
  .quad .Laot_word_entry_311
  .quad .Laot_word_name_312
  .quad aot_get_fw_6673722d69
.section .rodata
.Laot_word_name_313:
  .byte 58
  .byte 102
  .byte 115
  .byte 114
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_313:
  .quad .Laot_word_entry_312
  .quad .Laot_word_name_313
  .quad aot_set_fw_6673722d69
.section .text
aot_get_fw_6673722d696e646578:
  leaq reg_fw_6673722d696e646578(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6673722d696e646578:
  leaq reg_fw_6673722d696e646578(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_314:
  .byte 102
  .byte 115
  .byte 114
  .byte 45
  .byte 105
  .byte 110
  .byte 100
  .byte 101
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_314:
  .quad .Laot_word_entry_313
  .quad .Laot_word_name_314
  .quad aot_get_fw_6673722d696e646578
.section .rodata
.Laot_word_name_315:
  .byte 58
  .byte 102
  .byte 115
  .byte 114
  .byte 45
  .byte 105
  .byte 110
  .byte 100
  .byte 101
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_315:
  .quad .Laot_word_entry_314
  .quad .Laot_word_name_315
  .quad aot_set_fw_6673722d696e646578
.section .text
aot_get_fw_6666732d69:
  leaq reg_fw_6666732d69(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6666732d69:
  leaq reg_fw_6666732d69(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_316:
  .byte 102
  .byte 102
  .byte 115
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_316:
  .quad .Laot_word_entry_315
  .quad .Laot_word_name_316
  .quad aot_get_fw_6666732d69
.section .rodata
.Laot_word_name_317:
  .byte 58
  .byte 102
  .byte 102
  .byte 115
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_317:
  .quad .Laot_word_entry_316
  .quad .Laot_word_name_317
  .quad aot_set_fw_6666732d69
.section .text
aot_get_fw_76632d636f6c:
  leaq reg_fw_76632d636f6c(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_76632d636f6c:
  leaq reg_fw_76632d636f6c(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_318:
  .byte 118
  .byte 99
  .byte 45
  .byte 99
  .byte 111
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_318:
  .quad .Laot_word_entry_317
  .quad .Laot_word_name_318
  .quad aot_get_fw_76632d636f6c
.section .rodata
.Laot_word_name_319:
  .byte 58
  .byte 118
  .byte 99
  .byte 45
  .byte 99
  .byte 111
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_319:
  .quad .Laot_word_entry_318
  .quad .Laot_word_name_319
  .quad aot_set_fw_76632d636f6c
.section .text
aot_get_fw_76632d726f77:
  leaq reg_fw_76632d726f77(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_76632d726f77:
  leaq reg_fw_76632d726f77(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_320:
  .byte 118
  .byte 99
  .byte 45
  .byte 114
  .byte 111
  .byte 119
  .byte 0
.section .data
.Laot_word_entry_320:
  .quad .Laot_word_entry_319
  .quad .Laot_word_name_320
  .quad aot_get_fw_76632d726f77
.section .rodata
.Laot_word_name_321:
  .byte 58
  .byte 118
  .byte 99
  .byte 45
  .byte 114
  .byte 111
  .byte 119
  .byte 0
.section .data
.Laot_word_entry_321:
  .quad .Laot_word_entry_320
  .quad .Laot_word_name_321
  .quad aot_set_fw_76632d726f77
.section .text
aot_get_fw_76632d696e6b:
  leaq reg_fw_76632d696e6b(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_76632d696e6b:
  leaq reg_fw_76632d696e6b(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_322:
  .byte 118
  .byte 99
  .byte 45
  .byte 105
  .byte 110
  .byte 107
  .byte 0
.section .data
.Laot_word_entry_322:
  .quad .Laot_word_entry_321
  .quad .Laot_word_name_322
  .quad aot_get_fw_76632d696e6b
.section .rodata
.Laot_word_name_323:
  .byte 58
  .byte 118
  .byte 99
  .byte 45
  .byte 105
  .byte 110
  .byte 107
  .byte 0
.section .data
.Laot_word_entry_323:
  .quad .Laot_word_entry_322
  .quad .Laot_word_name_323
  .quad aot_set_fw_76632d696e6b
.section .text
aot_get_fw_76632d7079:
  leaq reg_fw_76632d7079(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_76632d7079:
  leaq reg_fw_76632d7079(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_324:
  .byte 118
  .byte 99
  .byte 45
  .byte 112
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_324:
  .quad .Laot_word_entry_323
  .quad .Laot_word_name_324
  .quad aot_get_fw_76632d7079
.section .rodata
.Laot_word_name_325:
  .byte 58
  .byte 118
  .byte 99
  .byte 45
  .byte 112
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_325:
  .quad .Laot_word_entry_324
  .quad .Laot_word_name_325
  .quad aot_set_fw_76632d7079
.section .text
aot_get_fw_76632d7078:
  leaq reg_fw_76632d7078(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_76632d7078:
  leaq reg_fw_76632d7078(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_326:
  .byte 118
  .byte 99
  .byte 45
  .byte 112
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_326:
  .quad .Laot_word_entry_325
  .quad .Laot_word_name_326
  .quad aot_get_fw_76632d7078
.section .rodata
.Laot_word_name_327:
  .byte 58
  .byte 118
  .byte 99
  .byte 45
  .byte 112
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_327:
  .quad .Laot_word_entry_326
  .quad .Laot_word_name_327
  .quad aot_set_fw_76632d7078
.section .text
aot_get_fw_76632d6267:
  leaq reg_fw_76632d6267(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_76632d6267:
  leaq reg_fw_76632d6267(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_328:
  .byte 118
  .byte 99
  .byte 45
  .byte 98
  .byte 103
  .byte 0
.section .data
.Laot_word_entry_328:
  .quad .Laot_word_entry_327
  .quad .Laot_word_name_328
  .quad aot_get_fw_76632d6267
.section .rodata
.Laot_word_name_329:
  .byte 58
  .byte 118
  .byte 99
  .byte 45
  .byte 98
  .byte 103
  .byte 0
.section .data
.Laot_word_entry_329:
  .quad .Laot_word_entry_328
  .quad .Laot_word_name_329
  .quad aot_set_fw_76632d6267
.section .text
aot_get_fw_76632d6369:
  leaq reg_fw_76632d6369(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_76632d6369:
  leaq reg_fw_76632d6369(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_330:
  .byte 118
  .byte 99
  .byte 45
  .byte 99
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_330:
  .quad .Laot_word_entry_329
  .quad .Laot_word_name_330
  .quad aot_get_fw_76632d6369
.section .rodata
.Laot_word_name_331:
  .byte 58
  .byte 118
  .byte 99
  .byte 45
  .byte 99
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_331:
  .quad .Laot_word_entry_330
  .quad .Laot_word_name_331
  .quad aot_set_fw_76632d6369
.section .text
aot_get_fw_76672d6368:
  leaq reg_fw_76672d6368(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_76672d6368:
  leaq reg_fw_76672d6368(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_332:
  .byte 118
  .byte 103
  .byte 45
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_332:
  .quad .Laot_word_entry_331
  .quad .Laot_word_name_332
  .quad aot_get_fw_76672d6368
.section .rodata
.Laot_word_name_333:
  .byte 58
  .byte 118
  .byte 103
  .byte 45
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_333:
  .quad .Laot_word_entry_332
  .quad .Laot_word_name_333
  .quad aot_set_fw_76672d6368
.section .text
aot_get_fw_76672d78:
  leaq reg_fw_76672d78(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_76672d78:
  leaq reg_fw_76672d78(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_334:
  .byte 118
  .byte 103
  .byte 45
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_334:
  .quad .Laot_word_entry_333
  .quad .Laot_word_name_334
  .quad aot_get_fw_76672d78
.section .rodata
.Laot_word_name_335:
  .byte 58
  .byte 118
  .byte 103
  .byte 45
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_335:
  .quad .Laot_word_entry_334
  .quad .Laot_word_name_335
  .quad aot_set_fw_76672d78
.section .text
aot_get_fw_76672d79:
  leaq reg_fw_76672d79(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_76672d79:
  leaq reg_fw_76672d79(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_336:
  .byte 118
  .byte 103
  .byte 45
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_336:
  .quad .Laot_word_entry_335
  .quad .Laot_word_name_336
  .quad aot_get_fw_76672d79
.section .rodata
.Laot_word_name_337:
  .byte 58
  .byte 118
  .byte 103
  .byte 45
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_337:
  .quad .Laot_word_entry_336
  .quad .Laot_word_name_337
  .quad aot_set_fw_76672d79
.section .text
aot_get_fw_76672d6779:
  leaq reg_fw_76672d6779(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_76672d6779:
  leaq reg_fw_76672d6779(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_338:
  .byte 118
  .byte 103
  .byte 45
  .byte 103
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_338:
  .quad .Laot_word_entry_337
  .quad .Laot_word_name_338
  .quad aot_get_fw_76672d6779
.section .rodata
.Laot_word_name_339:
  .byte 58
  .byte 118
  .byte 103
  .byte 45
  .byte 103
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_339:
  .quad .Laot_word_entry_338
  .quad .Laot_word_name_339
  .quad aot_set_fw_76672d6779
.section .text
aot_get_fw_76672d62697473:
  leaq reg_fw_76672d62697473(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_76672d62697473:
  leaq reg_fw_76672d62697473(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_340:
  .byte 118
  .byte 103
  .byte 45
  .byte 98
  .byte 105
  .byte 116
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_340:
  .quad .Laot_word_entry_339
  .quad .Laot_word_name_340
  .quad aot_get_fw_76672d62697473
.section .rodata
.Laot_word_name_341:
  .byte 58
  .byte 118
  .byte 103
  .byte 45
  .byte 98
  .byte 105
  .byte 116
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_341:
  .quad .Laot_word_entry_340
  .quad .Laot_word_name_341
  .quad aot_set_fw_76672d62697473
.section .text
aot_get_fw_76672d6d61736b:
  leaq reg_fw_76672d6d61736b(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_76672d6d61736b:
  leaq reg_fw_76672d6d61736b(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_342:
  .byte 118
  .byte 103
  .byte 45
  .byte 109
  .byte 97
  .byte 115
  .byte 107
  .byte 0
.section .data
.Laot_word_entry_342:
  .quad .Laot_word_entry_341
  .quad .Laot_word_name_342
  .quad aot_get_fw_76672d6d61736b
.section .rodata
.Laot_word_name_343:
  .byte 58
  .byte 118
  .byte 103
  .byte 45
  .byte 109
  .byte 97
  .byte 115
  .byte 107
  .byte 0
.section .data
.Laot_word_entry_343:
  .quad .Laot_word_entry_342
  .quad .Laot_word_name_343
  .quad aot_set_fw_76672d6d61736b
.section .text
aot_get_fw_76672d6778:
  leaq reg_fw_76672d6778(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_76672d6778:
  leaq reg_fw_76672d6778(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_344:
  .byte 118
  .byte 103
  .byte 45
  .byte 103
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_344:
  .quad .Laot_word_entry_343
  .quad .Laot_word_name_344
  .quad aot_get_fw_76672d6778
.section .rodata
.Laot_word_name_345:
  .byte 58
  .byte 118
  .byte 103
  .byte 45
  .byte 103
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_345:
  .quad .Laot_word_entry_344
  .quad .Laot_word_name_345
  .quad aot_set_fw_76672d6778
.section .text
aot_get_fw_76672d696e6b:
  leaq reg_fw_76672d696e6b(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_76672d696e6b:
  leaq reg_fw_76672d696e6b(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_346:
  .byte 118
  .byte 103
  .byte 45
  .byte 105
  .byte 110
  .byte 107
  .byte 0
.section .data
.Laot_word_entry_346:
  .quad .Laot_word_entry_345
  .quad .Laot_word_name_346
  .quad aot_get_fw_76672d696e6b
.section .rodata
.Laot_word_name_347:
  .byte 58
  .byte 118
  .byte 103
  .byte 45
  .byte 105
  .byte 110
  .byte 107
  .byte 0
.section .data
.Laot_word_entry_347:
  .quad .Laot_word_entry_346
  .quad .Laot_word_name_347
  .quad aot_set_fw_76672d696e6b
.section .text
aot_get_fw_76732d69:
  leaq reg_fw_76732d69(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_76732d69:
  leaq reg_fw_76732d69(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_348:
  .byte 118
  .byte 115
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_348:
  .quad .Laot_word_entry_347
  .quad .Laot_word_name_348
  .quad aot_get_fw_76732d69
.section .rodata
.Laot_word_name_349:
  .byte 58
  .byte 118
  .byte 115
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_349:
  .quad .Laot_word_entry_348
  .quad .Laot_word_name_349
  .quad aot_set_fw_76732d69
.section .text
aot_get_fw_76632d6368:
  leaq reg_fw_76632d6368(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_76632d6368:
  leaq reg_fw_76632d6368(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_350:
  .byte 118
  .byte 99
  .byte 45
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_350:
  .quad .Laot_word_entry_349
  .quad .Laot_word_name_350
  .quad aot_get_fw_76632d6368
.section .rodata
.Laot_word_name_351:
  .byte 58
  .byte 118
  .byte 99
  .byte 45
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_351:
  .quad .Laot_word_entry_350
  .quad .Laot_word_name_351
  .quad aot_set_fw_76632d6368
.section .text
aot_get_fw_76742d707472:
  leaq reg_fw_76742d707472(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_76742d707472:
  leaq reg_fw_76742d707472(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_352:
  .byte 118
  .byte 116
  .byte 45
  .byte 112
  .byte 116
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_352:
  .quad .Laot_word_entry_351
  .quad .Laot_word_name_352
  .quad aot_get_fw_76742d707472
.section .rodata
.Laot_word_name_353:
  .byte 58
  .byte 118
  .byte 116
  .byte 45
  .byte 112
  .byte 116
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_353:
  .quad .Laot_word_entry_352
  .quad .Laot_word_name_353
  .quad aot_set_fw_76742d707472
.section .text
aot_get_fw_76742d6368:
  leaq reg_fw_76742d6368(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_76742d6368:
  leaq reg_fw_76742d6368(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_354:
  .byte 118
  .byte 116
  .byte 45
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_354:
  .quad .Laot_word_entry_353
  .quad .Laot_word_name_354
  .quad aot_get_fw_76742d6368
.section .rodata
.Laot_word_name_355:
  .byte 58
  .byte 118
  .byte 116
  .byte 45
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_355:
  .quad .Laot_word_entry_354
  .quad .Laot_word_name_355
  .quad aot_set_fw_76742d6368
.section .text
aot_get_fw_646b2d7368696674:
  leaq reg_fw_646b2d7368696674(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_646b2d7368696674:
  leaq reg_fw_646b2d7368696674(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_356:
  .byte 100
  .byte 107
  .byte 45
  .byte 115
  .byte 104
  .byte 105
  .byte 102
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_356:
  .quad .Laot_word_entry_355
  .quad .Laot_word_name_356
  .quad aot_get_fw_646b2d7368696674
.section .rodata
.Laot_word_name_357:
  .byte 58
  .byte 100
  .byte 107
  .byte 45
  .byte 115
  .byte 104
  .byte 105
  .byte 102
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_357:
  .quad .Laot_word_entry_356
  .quad .Laot_word_name_357
  .quad aot_set_fw_646b2d7368696674
.section .text
aot_get_fw_646b2d657874656e646564:
  leaq reg_fw_646b2d657874656e646564(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_646b2d657874656e646564:
  leaq reg_fw_646b2d657874656e646564(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_358:
  .byte 100
  .byte 107
  .byte 45
  .byte 101
  .byte 120
  .byte 116
  .byte 101
  .byte 110
  .byte 100
  .byte 101
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_358:
  .quad .Laot_word_entry_357
  .quad .Laot_word_name_358
  .quad aot_get_fw_646b2d657874656e646564
.section .rodata
.Laot_word_name_359:
  .byte 58
  .byte 100
  .byte 107
  .byte 45
  .byte 101
  .byte 120
  .byte 116
  .byte 101
  .byte 110
  .byte 100
  .byte 101
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_359:
  .quad .Laot_word_entry_358
  .quad .Laot_word_name_359
  .quad aot_set_fw_646b2d657874656e646564
.section .text
aot_get_fw_646b2d636f6465:
  leaq reg_fw_646b2d636f6465(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_646b2d636f6465:
  leaq reg_fw_646b2d636f6465(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_360:
  .byte 100
  .byte 107
  .byte 45
  .byte 99
  .byte 111
  .byte 100
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_360:
  .quad .Laot_word_entry_359
  .quad .Laot_word_name_360
  .quad aot_get_fw_646b2d636f6465
.section .rodata
.Laot_word_name_361:
  .byte 58
  .byte 100
  .byte 107
  .byte 45
  .byte 99
  .byte 111
  .byte 100
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_361:
  .quad .Laot_word_entry_360
  .quad .Laot_word_name_361
  .quad aot_set_fw_646b2d636f6465
.section .text
aot_get_fw_646b2d7363616e:
  leaq reg_fw_646b2d7363616e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_646b2d7363616e:
  leaq reg_fw_646b2d7363616e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_362:
  .byte 100
  .byte 107
  .byte 45
  .byte 115
  .byte 99
  .byte 97
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_362:
  .quad .Laot_word_entry_361
  .quad .Laot_word_name_362
  .quad aot_get_fw_646b2d7363616e
.section .rodata
.Laot_word_name_363:
  .byte 58
  .byte 100
  .byte 107
  .byte 45
  .byte 115
  .byte 99
  .byte 97
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_363:
  .quad .Laot_word_entry_362
  .quad .Laot_word_name_363
  .quad aot_set_fw_646b2d7363616e
.section .text
aot_get_fw_646b2d6173636969:
  leaq reg_fw_646b2d6173636969(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_646b2d6173636969:
  leaq reg_fw_646b2d6173636969(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_364:
  .byte 100
  .byte 107
  .byte 45
  .byte 97
  .byte 115
  .byte 99
  .byte 105
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_364:
  .quad .Laot_word_entry_363
  .quad .Laot_word_name_364
  .quad aot_get_fw_646b2d6173636969
.section .rodata
.Laot_word_name_365:
  .byte 58
  .byte 100
  .byte 107
  .byte 45
  .byte 97
  .byte 115
  .byte 99
  .byte 105
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_365:
  .quad .Laot_word_entry_364
  .quad .Laot_word_name_365
  .quad aot_set_fw_646b2d6173636969
.section .text
aot_get_fw_646b2d63686172:
  leaq reg_fw_646b2d63686172(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_646b2d63686172:
  leaq reg_fw_646b2d63686172(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_366:
  .byte 100
  .byte 107
  .byte 45
  .byte 99
  .byte 104
  .byte 97
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_366:
  .quad .Laot_word_entry_365
  .quad .Laot_word_name_366
  .quad aot_get_fw_646b2d63686172
.section .rodata
.Laot_word_name_367:
  .byte 58
  .byte 100
  .byte 107
  .byte 45
  .byte 99
  .byte 104
  .byte 97
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_367:
  .quad .Laot_word_entry_366
  .quad .Laot_word_name_367
  .quad aot_set_fw_646b2d63686172
.section .text
aot_get_fw_646b2d6576656e74:
  leaq reg_fw_646b2d6576656e74(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_646b2d6576656e74:
  leaq reg_fw_646b2d6576656e74(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_368:
  .byte 100
  .byte 107
  .byte 45
  .byte 101
  .byte 118
  .byte 101
  .byte 110
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_368:
  .quad .Laot_word_entry_367
  .quad .Laot_word_name_368
  .quad aot_get_fw_646b2d6576656e74
.section .rodata
.Laot_word_name_369:
  .byte 58
  .byte 100
  .byte 107
  .byte 45
  .byte 101
  .byte 118
  .byte 101
  .byte 110
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_369:
  .quad .Laot_word_entry_368
  .quad .Laot_word_name_369
  .quad aot_set_fw_646b2d6576656e74
.section .text
aot_get_fw_7332657162:
  leaq reg_fw_7332657162(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7332657162:
  leaq reg_fw_7332657162(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_370:
  .byte 115
  .byte 50
  .byte 101
  .byte 113
  .byte 98
  .byte 0
.section .data
.Laot_word_entry_370:
  .quad .Laot_word_entry_369
  .quad .Laot_word_name_370
  .quad aot_get_fw_7332657162
.section .rodata
.Laot_word_name_371:
  .byte 58
  .byte 115
  .byte 50
  .byte 101
  .byte 113
  .byte 98
  .byte 0
.section .data
.Laot_word_entry_371:
  .quad .Laot_word_entry_370
  .quad .Laot_word_name_371
  .quad aot_set_fw_7332657162
.section .text
aot_get_fw_7332657161:
  leaq reg_fw_7332657161(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7332657161:
  leaq reg_fw_7332657161(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_372:
  .byte 115
  .byte 50
  .byte 101
  .byte 113
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_372:
  .quad .Laot_word_entry_371
  .quad .Laot_word_name_372
  .quad aot_get_fw_7332657161
.section .rodata
.Laot_word_name_373:
  .byte 58
  .byte 115
  .byte 50
  .byte 101
  .byte 113
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_373:
  .quad .Laot_word_entry_372
  .quad .Laot_word_name_373
  .quad aot_set_fw_7332657161
.section .text
aot_get_fw_7332657163:
  leaq reg_fw_7332657163(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7332657163:
  leaq reg_fw_7332657163(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_374:
  .byte 115
  .byte 50
  .byte 101
  .byte 113
  .byte 99
  .byte 0
.section .data
.Laot_word_entry_374:
  .quad .Laot_word_entry_373
  .quad .Laot_word_name_374
  .quad aot_get_fw_7332657163
.section .rodata
.Laot_word_name_375:
  .byte 58
  .byte 115
  .byte 50
  .byte 101
  .byte 113
  .byte 99
  .byte 0
.section .data
.Laot_word_entry_375:
  .quad .Laot_word_entry_374
  .quad .Laot_word_name_375
  .quad aot_set_fw_7332657163
.section .text
aot_get_fw_73326e6565646c65:
  leaq reg_fw_73326e6565646c65(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73326e6565646c65:
  leaq reg_fw_73326e6565646c65(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_376:
  .byte 115
  .byte 50
  .byte 110
  .byte 101
  .byte 101
  .byte 100
  .byte 108
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_376:
  .quad .Laot_word_entry_375
  .quad .Laot_word_name_376
  .quad aot_get_fw_73326e6565646c65
.section .rodata
.Laot_word_name_377:
  .byte 58
  .byte 115
  .byte 50
  .byte 110
  .byte 101
  .byte 101
  .byte 100
  .byte 108
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_377:
  .quad .Laot_word_entry_376
  .quad .Laot_word_name_377
  .quad aot_set_fw_73326e6565646c65
.section .text
aot_get_fw_73326e6f6465:
  leaq reg_fw_73326e6f6465(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73326e6f6465:
  leaq reg_fw_73326e6f6465(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_378:
  .byte 115
  .byte 50
  .byte 110
  .byte 111
  .byte 100
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_378:
  .quad .Laot_word_entry_377
  .quad .Laot_word_name_378
  .quad aot_get_fw_73326e6f6465
.section .rodata
.Laot_word_name_379:
  .byte 58
  .byte 115
  .byte 50
  .byte 110
  .byte 111
  .byte 100
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_379:
  .quad .Laot_word_entry_378
  .quad .Laot_word_name_379
  .quad aot_set_fw_73326e6f6465
.section .text
aot_get_fw_7332746f6b:
  leaq reg_fw_7332746f6b(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7332746f6b:
  leaq reg_fw_7332746f6b(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_380:
  .byte 115
  .byte 50
  .byte 116
  .byte 111
  .byte 107
  .byte 0
.section .data
.Laot_word_entry_380:
  .quad .Laot_word_entry_379
  .quad .Laot_word_name_380
  .quad aot_get_fw_7332746f6b
.section .rodata
.Laot_word_name_381:
  .byte 58
  .byte 115
  .byte 50
  .byte 116
  .byte 111
  .byte 107
  .byte 0
.section .data
.Laot_word_entry_381:
  .quad .Laot_word_entry_380
  .quad .Laot_word_name_381
  .quad aot_set_fw_7332746f6b
.section .text
aot_get_fw_73327772697465:
  leaq reg_fw_73327772697465(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73327772697465:
  leaq reg_fw_73327772697465(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_382:
  .byte 115
  .byte 50
  .byte 119
  .byte 114
  .byte 105
  .byte 116
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_382:
  .quad .Laot_word_entry_381
  .quad .Laot_word_name_382
  .quad aot_get_fw_73327772697465
.section .rodata
.Laot_word_name_383:
  .byte 58
  .byte 115
  .byte 50
  .byte 119
  .byte 114
  .byte 105
  .byte 116
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_383:
  .quad .Laot_word_entry_382
  .quad .Laot_word_name_383
  .quad aot_set_fw_73327772697465
.section .text
aot_get_fw_733271756f7465:
  leaq reg_fw_733271756f7465(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_733271756f7465:
  leaq reg_fw_733271756f7465(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_384:
  .byte 115
  .byte 50
  .byte 113
  .byte 117
  .byte 111
  .byte 116
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_384:
  .quad .Laot_word_entry_383
  .quad .Laot_word_name_384
  .quad aot_get_fw_733271756f7465
.section .rodata
.Laot_word_name_385:
  .byte 58
  .byte 115
  .byte 50
  .byte 113
  .byte 117
  .byte 111
  .byte 116
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_385:
  .quad .Laot_word_entry_384
  .quad .Laot_word_name_385
  .quad aot_set_fw_733271756f7465
.section .text
aot_get_fw_73326368:
  leaq reg_fw_73326368(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73326368:
  leaq reg_fw_73326368(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_386:
  .byte 115
  .byte 50
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_386:
  .quad .Laot_word_entry_385
  .quad .Laot_word_name_386
  .quad aot_get_fw_73326368
.section .rodata
.Laot_word_name_387:
  .byte 58
  .byte 115
  .byte 50
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_387:
  .quad .Laot_word_entry_386
  .quad .Laot_word_name_387
  .quad aot_set_fw_73326368
.section .text
aot_get_fw_733270:
  leaq reg_fw_733270(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_733270:
  leaq reg_fw_733270(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_388:
  .byte 115
  .byte 50
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_388:
  .quad .Laot_word_entry_387
  .quad .Laot_word_name_388
  .quad aot_get_fw_733270
.section .rodata
.Laot_word_name_389:
  .byte 58
  .byte 115
  .byte 50
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_389:
  .quad .Laot_word_entry_388
  .quad .Laot_word_name_389
  .quad aot_set_fw_733270
.section .text
aot_get_fw_733263686172:
  leaq reg_fw_733263686172(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_733263686172:
  leaq reg_fw_733263686172(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_390:
  .byte 115
  .byte 50
  .byte 99
  .byte 104
  .byte 97
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_390:
  .quad .Laot_word_entry_389
  .quad .Laot_word_name_390
  .quad aot_get_fw_733263686172
.section .rodata
.Laot_word_name_391:
  .byte 58
  .byte 115
  .byte 50
  .byte 99
  .byte 104
  .byte 97
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_391:
  .quad .Laot_word_entry_390
  .quad .Laot_word_name_391
  .quad aot_set_fw_733263686172
.section .text
aot_get_fw_73327570:
  leaq reg_fw_73327570(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73327570:
  leaq reg_fw_73327570(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_392:
  .byte 115
  .byte 50
  .byte 117
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_392:
  .quad .Laot_word_entry_391
  .quad .Laot_word_name_392
  .quad aot_get_fw_73327570
.section .rodata
.Laot_word_name_393:
  .byte 58
  .byte 115
  .byte 50
  .byte 117
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_393:
  .quad .Laot_word_entry_392
  .quad .Laot_word_name_393
  .quad aot_set_fw_73327570
.section .text
aot_get_fw_733262617365:
  leaq reg_fw_733262617365(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_733262617365:
  leaq reg_fw_733262617365(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_394:
  .byte 115
  .byte 50
  .byte 98
  .byte 97
  .byte 115
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_394:
  .quad .Laot_word_entry_393
  .quad .Laot_word_name_394
  .quad aot_get_fw_733262617365
.section .rodata
.Laot_word_name_395:
  .byte 58
  .byte 115
  .byte 50
  .byte 98
  .byte 97
  .byte 115
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_395:
  .quad .Laot_word_entry_394
  .quad .Laot_word_name_395
  .quad aot_set_fw_733262617365
.section .text
aot_get_fw_7332616363:
  leaq reg_fw_7332616363(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7332616363:
  leaq reg_fw_7332616363(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_396:
  .byte 115
  .byte 50
  .byte 97
  .byte 99
  .byte 99
  .byte 0
.section .data
.Laot_word_entry_396:
  .quad .Laot_word_entry_395
  .quad .Laot_word_name_396
  .quad aot_get_fw_7332616363
.section .rodata
.Laot_word_name_397:
  .byte 58
  .byte 115
  .byte 50
  .byte 97
  .byte 99
  .byte 99
  .byte 0
.section .data
.Laot_word_entry_397:
  .quad .Laot_word_entry_396
  .quad .Laot_word_name_397
  .quad aot_set_fw_7332616363
.section .text
aot_get_fw_73327365656e:
  leaq reg_fw_73327365656e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73327365656e:
  leaq reg_fw_73327365656e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_398:
  .byte 115
  .byte 50
  .byte 115
  .byte 101
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_398:
  .quad .Laot_word_entry_397
  .quad .Laot_word_name_398
  .quad aot_get_fw_73327365656e
.section .rodata
.Laot_word_name_399:
  .byte 58
  .byte 115
  .byte 50
  .byte 115
  .byte 101
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_399:
  .quad .Laot_word_entry_398
  .quad .Laot_word_name_399
  .quad aot_set_fw_73327365656e
.section .text
aot_get_fw_7332756368:
  leaq reg_fw_7332756368(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7332756368:
  leaq reg_fw_7332756368(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_400:
  .byte 115
  .byte 50
  .byte 117
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_400:
  .quad .Laot_word_entry_399
  .quad .Laot_word_name_400
  .quad aot_get_fw_7332756368
.section .rodata
.Laot_word_name_401:
  .byte 58
  .byte 115
  .byte 50
  .byte 117
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_401:
  .quad .Laot_word_entry_400
  .quad .Laot_word_name_401
  .quad aot_set_fw_7332756368
.section .text
aot_get_fw_7332646967697476616c6964:
  leaq reg_fw_7332646967697476616c6964(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7332646967697476616c6964:
  leaq reg_fw_7332646967697476616c6964(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_402:
  .byte 115
  .byte 50
  .byte 100
  .byte 105
  .byte 103
  .byte 105
  .byte 116
  .byte 118
  .byte 97
  .byte 108
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_402:
  .quad .Laot_word_entry_401
  .quad .Laot_word_name_402
  .quad aot_get_fw_7332646967697476616c6964
.section .rodata
.Laot_word_name_403:
  .byte 58
  .byte 115
  .byte 50
  .byte 100
  .byte 105
  .byte 103
  .byte 105
  .byte 116
  .byte 118
  .byte 97
  .byte 108
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_403:
  .quad .Laot_word_entry_402
  .quad .Laot_word_name_403
  .quad aot_set_fw_7332646967697476616c6964
.section .text
aot_get_fw_73326469676974:
  leaq reg_fw_73326469676974(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73326469676974:
  leaq reg_fw_73326469676974(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_404:
  .byte 115
  .byte 50
  .byte 100
  .byte 105
  .byte 103
  .byte 105
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_404:
  .quad .Laot_word_entry_403
  .quad .Laot_word_name_404
  .quad aot_get_fw_73326469676974
.section .rodata
.Laot_word_name_405:
  .byte 58
  .byte 115
  .byte 50
  .byte 100
  .byte 105
  .byte 103
  .byte 105
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_405:
  .quad .Laot_word_entry_404
  .quad .Laot_word_name_405
  .quad aot_set_fw_73326469676974
.section .text
aot_get_fw_7332646563707472:
  leaq reg_fw_7332646563707472(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7332646563707472:
  leaq reg_fw_7332646563707472(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_406:
  .byte 115
  .byte 50
  .byte 100
  .byte 101
  .byte 99
  .byte 112
  .byte 116
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_406:
  .quad .Laot_word_entry_405
  .quad .Laot_word_name_406
  .quad aot_get_fw_7332646563707472
.section .rodata
.Laot_word_name_407:
  .byte 58
  .byte 115
  .byte 50
  .byte 100
  .byte 101
  .byte 99
  .byte 112
  .byte 116
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_407:
  .quad .Laot_word_entry_406
  .quad .Laot_word_name_407
  .quad aot_set_fw_7332646563707472
.section .text
aot_get_fw_7332646563696d616c:
  leaq reg_fw_7332646563696d616c(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7332646563696d616c:
  leaq reg_fw_7332646563696d616c(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_408:
  .byte 115
  .byte 50
  .byte 100
  .byte 101
  .byte 99
  .byte 105
  .byte 109
  .byte 97
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_408:
  .quad .Laot_word_entry_407
  .quad .Laot_word_name_408
  .quad aot_get_fw_7332646563696d616c
.section .rodata
.Laot_word_name_409:
  .byte 58
  .byte 115
  .byte 50
  .byte 100
  .byte 101
  .byte 99
  .byte 105
  .byte 109
  .byte 97
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_409:
  .quad .Laot_word_entry_408
  .quad .Laot_word_name_409
  .quad aot_set_fw_7332646563696d616c
.section .text
aot_get_fw_73327363616c65:
  leaq reg_fw_73327363616c65(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73327363616c65:
  leaq reg_fw_73327363616c65(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_410:
  .byte 115
  .byte 50
  .byte 115
  .byte 99
  .byte 97
  .byte 108
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_410:
  .quad .Laot_word_entry_409
  .quad .Laot_word_name_410
  .quad aot_get_fw_73327363616c65
.section .rodata
.Laot_word_name_411:
  .byte 58
  .byte 115
  .byte 50
  .byte 115
  .byte 99
  .byte 97
  .byte 108
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_411:
  .quad .Laot_word_entry_410
  .quad .Laot_word_name_411
  .quad aot_set_fw_73327363616c65
.section .text
aot_get_fw_7332646368:
  leaq reg_fw_7332646368(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7332646368:
  leaq reg_fw_7332646368(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_412:
  .byte 115
  .byte 50
  .byte 100
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_412:
  .quad .Laot_word_entry_411
  .quad .Laot_word_name_412
  .quad aot_get_fw_7332646368
.section .rodata
.Laot_word_name_413:
  .byte 58
  .byte 115
  .byte 50
  .byte 100
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_413:
  .quad .Laot_word_entry_412
  .quad .Laot_word_name_413
  .quad aot_set_fw_7332646368
.section .text
aot_get_fw_73326476616c6964:
  leaq reg_fw_73326476616c6964(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73326476616c6964:
  leaq reg_fw_73326476616c6964(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_414:
  .byte 115
  .byte 50
  .byte 100
  .byte 118
  .byte 97
  .byte 108
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_414:
  .quad .Laot_word_entry_413
  .quad .Laot_word_name_414
  .quad aot_get_fw_73326476616c6964
.section .rodata
.Laot_word_name_415:
  .byte 58
  .byte 115
  .byte 50
  .byte 100
  .byte 118
  .byte 97
  .byte 108
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_415:
  .quad .Laot_word_entry_414
  .quad .Laot_word_name_415
  .quad aot_set_fw_73326476616c6964
.section .text
aot_get_fw_7332646967:
  leaq reg_fw_7332646967(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7332646967:
  leaq reg_fw_7332646967(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_416:
  .byte 115
  .byte 50
  .byte 100
  .byte 105
  .byte 103
  .byte 0
.section .data
.Laot_word_entry_416:
  .quad .Laot_word_entry_415
  .quad .Laot_word_name_416
  .quad aot_get_fw_7332646967
.section .rodata
.Laot_word_name_417:
  .byte 58
  .byte 115
  .byte 50
  .byte 100
  .byte 105
  .byte 103
  .byte 0
.section .data
.Laot_word_entry_417:
  .quad .Laot_word_entry_416
  .quad .Laot_word_name_417
  .quad aot_set_fw_7332646967
.section .text
aot_get_fw_73326e70:
  leaq reg_fw_73326e70(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73326e70:
  leaq reg_fw_73326e70(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_418:
  .byte 115
  .byte 50
  .byte 110
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_418:
  .quad .Laot_word_entry_417
  .quad .Laot_word_name_418
  .quad aot_get_fw_73326e70
.section .rodata
.Laot_word_name_419:
  .byte 58
  .byte 115
  .byte 50
  .byte 110
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_419:
  .quad .Laot_word_entry_418
  .quad .Laot_word_name_419
  .quad aot_set_fw_73326e70
.section .text
aot_get_fw_73327369676e:
  leaq reg_fw_73327369676e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73327369676e:
  leaq reg_fw_73327369676e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_420:
  .byte 115
  .byte 50
  .byte 115
  .byte 105
  .byte 103
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_420:
  .quad .Laot_word_entry_419
  .quad .Laot_word_name_420
  .quad aot_get_fw_73327369676e
.section .rodata
.Laot_word_name_421:
  .byte 58
  .byte 115
  .byte 50
  .byte 115
  .byte 105
  .byte 103
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_421:
  .quad .Laot_word_entry_420
  .quad .Laot_word_name_421
  .quad aot_set_fw_73327369676e
.section .text
aot_get_fw_73326e756d657261746f7276616c6964:
  leaq reg_fw_73326e756d657261746f7276616c6964(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73326e756d657261746f7276616c6964:
  leaq reg_fw_73326e756d657261746f7276616c6964(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_422:
  .byte 115
  .byte 50
  .byte 110
  .byte 117
  .byte 109
  .byte 101
  .byte 114
  .byte 97
  .byte 116
  .byte 111
  .byte 114
  .byte 118
  .byte 97
  .byte 108
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_422:
  .quad .Laot_word_entry_421
  .quad .Laot_word_name_422
  .quad aot_get_fw_73326e756d657261746f7276616c6964
.section .rodata
.Laot_word_name_423:
  .byte 58
  .byte 115
  .byte 50
  .byte 110
  .byte 117
  .byte 109
  .byte 101
  .byte 114
  .byte 97
  .byte 116
  .byte 111
  .byte 114
  .byte 118
  .byte 97
  .byte 108
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_423:
  .quad .Laot_word_entry_422
  .quad .Laot_word_name_423
  .quad aot_set_fw_73326e756d657261746f7276616c6964
.section .text
aot_get_fw_7332656e64707472:
  leaq reg_fw_7332656e64707472(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7332656e64707472:
  leaq reg_fw_7332656e64707472(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_424:
  .byte 115
  .byte 50
  .byte 101
  .byte 110
  .byte 100
  .byte 112
  .byte 116
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_424:
  .quad .Laot_word_entry_423
  .quad .Laot_word_name_424
  .quad aot_get_fw_7332656e64707472
.section .rodata
.Laot_word_name_425:
  .byte 58
  .byte 115
  .byte 50
  .byte 101
  .byte 110
  .byte 100
  .byte 112
  .byte 116
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_425:
  .quad .Laot_word_entry_424
  .quad .Laot_word_name_425
  .quad aot_set_fw_7332656e64707472
.section .text
aot_get_fw_73326e756d657261746f72:
  leaq reg_fw_73326e756d657261746f72(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73326e756d657261746f72:
  leaq reg_fw_73326e756d657261746f72(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_426:
  .byte 115
  .byte 50
  .byte 110
  .byte 117
  .byte 109
  .byte 101
  .byte 114
  .byte 97
  .byte 116
  .byte 111
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_426:
  .quad .Laot_word_entry_425
  .quad .Laot_word_name_426
  .quad aot_get_fw_73326e756d657261746f72
.section .rodata
.Laot_word_name_427:
  .byte 58
  .byte 115
  .byte 50
  .byte 110
  .byte 117
  .byte 109
  .byte 101
  .byte 114
  .byte 97
  .byte 116
  .byte 111
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_427:
  .quad .Laot_word_entry_426
  .quad .Laot_word_name_427
  .quad aot_set_fw_73326e756d657261746f72
.section .text
aot_get_fw_73326465636f6b:
  leaq reg_fw_73326465636f6b(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73326465636f6b:
  leaq reg_fw_73326465636f6b(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_428:
  .byte 115
  .byte 50
  .byte 100
  .byte 101
  .byte 99
  .byte 111
  .byte 107
  .byte 0
.section .data
.Laot_word_entry_428:
  .quad .Laot_word_entry_427
  .quad .Laot_word_name_428
  .quad aot_get_fw_73326465636f6b
.section .rodata
.Laot_word_name_429:
  .byte 58
  .byte 115
  .byte 50
  .byte 100
  .byte 101
  .byte 99
  .byte 111
  .byte 107
  .byte 0
.section .data
.Laot_word_entry_429:
  .quad .Laot_word_entry_428
  .quad .Laot_word_name_429
  .quad aot_set_fw_73326465636f6b
.section .text
aot_get_fw_73326465637363616c65:
  leaq reg_fw_73326465637363616c65(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73326465637363616c65:
  leaq reg_fw_73326465637363616c65(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_430:
  .byte 115
  .byte 50
  .byte 100
  .byte 101
  .byte 99
  .byte 115
  .byte 99
  .byte 97
  .byte 108
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_430:
  .quad .Laot_word_entry_429
  .quad .Laot_word_name_430
  .quad aot_get_fw_73326465637363616c65
.section .rodata
.Laot_word_name_431:
  .byte 58
  .byte 115
  .byte 50
  .byte 100
  .byte 101
  .byte 99
  .byte 115
  .byte 99
  .byte 97
  .byte 108
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_431:
  .quad .Laot_word_entry_430
  .quad .Laot_word_name_431
  .quad aot_set_fw_73326465637363616c65
.section .text
aot_get_fw_733264656366726163:
  leaq reg_fw_733264656366726163(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_733264656366726163:
  leaq reg_fw_733264656366726163(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_432:
  .byte 115
  .byte 50
  .byte 100
  .byte 101
  .byte 99
  .byte 102
  .byte 114
  .byte 97
  .byte 99
  .byte 0
.section .data
.Laot_word_entry_432:
  .quad .Laot_word_entry_431
  .quad .Laot_word_name_432
  .quad aot_get_fw_733264656366726163
.section .rodata
.Laot_word_name_433:
  .byte 58
  .byte 115
  .byte 50
  .byte 100
  .byte 101
  .byte 99
  .byte 102
  .byte 114
  .byte 97
  .byte 99
  .byte 0
.section .data
.Laot_word_entry_433:
  .quad .Laot_word_entry_432
  .quad .Laot_word_name_433
  .quad aot_set_fw_733264656366726163
.section .text
aot_get_fw_733264656e6f6d76616c6964:
  leaq reg_fw_733264656e6f6d76616c6964(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_733264656e6f6d76616c6964:
  leaq reg_fw_733264656e6f6d76616c6964(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_434:
  .byte 115
  .byte 50
  .byte 100
  .byte 101
  .byte 110
  .byte 111
  .byte 109
  .byte 118
  .byte 97
  .byte 108
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_434:
  .quad .Laot_word_entry_433
  .quad .Laot_word_name_434
  .quad aot_get_fw_733264656e6f6d76616c6964
.section .rodata
.Laot_word_name_435:
  .byte 58
  .byte 115
  .byte 50
  .byte 100
  .byte 101
  .byte 110
  .byte 111
  .byte 109
  .byte 118
  .byte 97
  .byte 108
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_435:
  .quad .Laot_word_entry_434
  .quad .Laot_word_name_435
  .quad aot_set_fw_733264656e6f6d76616c6964
.section .text
aot_get_fw_733266696e616c707472:
  leaq reg_fw_733266696e616c707472(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_733266696e616c707472:
  leaq reg_fw_733266696e616c707472(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_436:
  .byte 115
  .byte 50
  .byte 102
  .byte 105
  .byte 110
  .byte 97
  .byte 108
  .byte 112
  .byte 116
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_436:
  .quad .Laot_word_entry_435
  .quad .Laot_word_name_436
  .quad aot_get_fw_733266696e616c707472
.section .rodata
.Laot_word_name_437:
  .byte 58
  .byte 115
  .byte 50
  .byte 102
  .byte 105
  .byte 110
  .byte 97
  .byte 108
  .byte 112
  .byte 116
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_437:
  .quad .Laot_word_entry_436
  .quad .Laot_word_name_437
  .quad aot_set_fw_733266696e616c707472
.section .text
aot_get_fw_733264656e6f6d696e61746f72:
  leaq reg_fw_733264656e6f6d696e61746f72(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_733264656e6f6d696e61746f72:
  leaq reg_fw_733264656e6f6d696e61746f72(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_438:
  .byte 115
  .byte 50
  .byte 100
  .byte 101
  .byte 110
  .byte 111
  .byte 109
  .byte 105
  .byte 110
  .byte 97
  .byte 116
  .byte 111
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_438:
  .quad .Laot_word_entry_437
  .quad .Laot_word_name_438
  .quad aot_get_fw_733264656e6f6d696e61746f72
.section .rodata
.Laot_word_name_439:
  .byte 58
  .byte 115
  .byte 50
  .byte 100
  .byte 101
  .byte 110
  .byte 111
  .byte 109
  .byte 105
  .byte 110
  .byte 97
  .byte 116
  .byte 111
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_439:
  .quad .Laot_word_entry_438
  .quad .Laot_word_name_439
  .quad aot_set_fw_733264656e6f6d696e61746f72
.section .text
aot_get_fw_73326279746576616c7565:
  leaq reg_fw_73326279746576616c7565(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73326279746576616c7565:
  leaq reg_fw_73326279746576616c7565(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_440:
  .byte 115
  .byte 50
  .byte 98
  .byte 121
  .byte 116
  .byte 101
  .byte 118
  .byte 97
  .byte 108
  .byte 117
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_440:
  .quad .Laot_word_entry_439
  .quad .Laot_word_name_440
  .quad aot_get_fw_73326279746576616c7565
.section .rodata
.Laot_word_name_441:
  .byte 58
  .byte 115
  .byte 50
  .byte 98
  .byte 121
  .byte 116
  .byte 101
  .byte 118
  .byte 97
  .byte 108
  .byte 117
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_441:
  .quad .Laot_word_entry_440
  .quad .Laot_word_name_441
  .quad aot_set_fw_73326279746576616c7565
.section .text
aot_get_fw_73326f7574:
  leaq reg_fw_73326f7574(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73326f7574:
  leaq reg_fw_73326f7574(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_442:
  .byte 115
  .byte 50
  .byte 111
  .byte 117
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_442:
  .quad .Laot_word_entry_441
  .quad .Laot_word_name_442
  .quad aot_get_fw_73326f7574
.section .rodata
.Laot_word_name_443:
  .byte 58
  .byte 115
  .byte 50
  .byte 111
  .byte 117
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_443:
  .quad .Laot_word_entry_442
  .quad .Laot_word_name_443
  .quad aot_set_fw_73326f7574
.section .text
aot_get_fw_7332776f7264:
  leaq reg_fw_7332776f7264(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7332776f7264:
  leaq reg_fw_7332776f7264(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_444:
  .byte 115
  .byte 50
  .byte 119
  .byte 111
  .byte 114
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_444:
  .quad .Laot_word_entry_443
  .quad .Laot_word_name_444
  .quad aot_get_fw_7332776f7264
.section .rodata
.Laot_word_name_445:
  .byte 58
  .byte 115
  .byte 50
  .byte 119
  .byte 111
  .byte 114
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_445:
  .quad .Laot_word_entry_444
  .quad .Laot_word_name_445
  .quad aot_set_fw_7332776f7264
.section .text
aot_get_fw_733269:
  leaq reg_fw_733269(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_733269:
  leaq reg_fw_733269(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_446:
  .byte 115
  .byte 50
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_446:
  .quad .Laot_word_entry_445
  .quad .Laot_word_name_446
  .quad aot_get_fw_733269
.section .rodata
.Laot_word_name_447:
  .byte 58
  .byte 115
  .byte 50
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_447:
  .quad .Laot_word_entry_446
  .quad .Laot_word_name_447
  .quad aot_set_fw_733269
.section .text
aot_get_fw_733263616c6c6565:
  leaq reg_fw_733263616c6c6565(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_733263616c6c6565:
  leaq reg_fw_733263616c6c6565(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_448:
  .byte 115
  .byte 50
  .byte 99
  .byte 97
  .byte 108
  .byte 108
  .byte 101
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_448:
  .quad .Laot_word_entry_447
  .quad .Laot_word_name_448
  .quad aot_get_fw_733263616c6c6565
.section .rodata
.Laot_word_name_449:
  .byte 58
  .byte 115
  .byte 50
  .byte 99
  .byte 97
  .byte 108
  .byte 108
  .byte 101
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_449:
  .quad .Laot_word_entry_448
  .quad .Laot_word_name_449
  .quad aot_set_fw_733263616c6c6565
.section .text
aot_get_fw_733264656e76616c:
  leaq reg_fw_733264656e76616c(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_733264656e76616c:
  leaq reg_fw_733264656e76616c(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_450:
  .byte 115
  .byte 50
  .byte 100
  .byte 101
  .byte 110
  .byte 118
  .byte 97
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_450:
  .quad .Laot_word_entry_449
  .quad .Laot_word_name_450
  .quad aot_get_fw_733264656e76616c
.section .rodata
.Laot_word_name_451:
  .byte 58
  .byte 115
  .byte 50
  .byte 100
  .byte 101
  .byte 110
  .byte 118
  .byte 97
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_451:
  .quad .Laot_word_entry_450
  .quad .Laot_word_name_451
  .quad aot_set_fw_733264656e76616c
.section .text
aot_get_fw_73326c69746572616c:
  leaq reg_fw_73326c69746572616c(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73326c69746572616c:
  leaq reg_fw_73326c69746572616c(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_452:
  .byte 115
  .byte 50
  .byte 108
  .byte 105
  .byte 116
  .byte 101
  .byte 114
  .byte 97
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_452:
  .quad .Laot_word_entry_451
  .quad .Laot_word_name_452
  .quad aot_get_fw_73326c69746572616c
.section .rodata
.Laot_word_name_453:
  .byte 58
  .byte 115
  .byte 50
  .byte 108
  .byte 105
  .byte 116
  .byte 101
  .byte 114
  .byte 97
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_453:
  .quad .Laot_word_entry_452
  .quad .Laot_word_name_453
  .quad aot_set_fw_73326c69746572616c
.section .text
aot_get_fw_733275333276:
  leaq reg_fw_733275333276(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_733275333276:
  leaq reg_fw_733275333276(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_454:
  .byte 115
  .byte 50
  .byte 117
  .byte 51
  .byte 50
  .byte 118
  .byte 0
.section .data
.Laot_word_entry_454:
  .quad .Laot_word_entry_453
  .quad .Laot_word_name_454
  .quad aot_get_fw_733275333276
.section .rodata
.Laot_word_name_455:
  .byte 58
  .byte 115
  .byte 50
  .byte 117
  .byte 51
  .byte 50
  .byte 118
  .byte 0
.section .data
.Laot_word_entry_455:
  .quad .Laot_word_entry_454
  .quad .Laot_word_name_455
  .quad aot_set_fw_733275333276
.section .text
aot_get_fw_733275333269:
  leaq reg_fw_733275333269(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_733275333269:
  leaq reg_fw_733275333269(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_456:
  .byte 115
  .byte 50
  .byte 117
  .byte 51
  .byte 50
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_456:
  .quad .Laot_word_entry_455
  .quad .Laot_word_name_456
  .quad aot_get_fw_733275333269
.section .rodata
.Laot_word_name_457:
  .byte 58
  .byte 115
  .byte 50
  .byte 117
  .byte 51
  .byte 50
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_457:
  .quad .Laot_word_entry_456
  .quad .Laot_word_name_457
  .quad aot_set_fw_733275333269
.section .text
aot_get_fw_73327776:
  leaq reg_fw_73327776(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73327776:
  leaq reg_fw_73327776(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_458:
  .byte 115
  .byte 50
  .byte 119
  .byte 118
  .byte 0
.section .data
.Laot_word_entry_458:
  .quad .Laot_word_entry_457
  .quad .Laot_word_name_458
  .quad aot_get_fw_73327776
.section .rodata
.Laot_word_name_459:
  .byte 58
  .byte 115
  .byte 50
  .byte 119
  .byte 118
  .byte 0
.section .data
.Laot_word_entry_459:
  .quad .Laot_word_entry_458
  .quad .Laot_word_name_459
  .quad aot_set_fw_73327776
.section .text
aot_get_fw_73327761:
  leaq reg_fw_73327761(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73327761:
  leaq reg_fw_73327761(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_460:
  .byte 115
  .byte 50
  .byte 119
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_460:
  .quad .Laot_word_entry_459
  .quad .Laot_word_name_460
  .quad aot_get_fw_73327761
.section .rodata
.Laot_word_name_461:
  .byte 58
  .byte 115
  .byte 50
  .byte 119
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_461:
  .quad .Laot_word_entry_460
  .quad .Laot_word_name_461
  .quad aot_set_fw_73327761
.section .text
aot_get_fw_73327769:
  leaq reg_fw_73327769(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73327769:
  leaq reg_fw_73327769(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_462:
  .byte 115
  .byte 50
  .byte 119
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_462:
  .quad .Laot_word_entry_461
  .quad .Laot_word_name_462
  .quad aot_get_fw_73327769
.section .rodata
.Laot_word_name_463:
  .byte 58
  .byte 115
  .byte 50
  .byte 119
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_463:
  .quad .Laot_word_entry_462
  .quad .Laot_word_name_463
  .quad aot_set_fw_73327769
.section .text
aot_get_fw_73327261:
  leaq reg_fw_73327261(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73327261:
  leaq reg_fw_73327261(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_464:
  .byte 115
  .byte 50
  .byte 114
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_464:
  .quad .Laot_word_entry_463
  .quad .Laot_word_name_464
  .quad aot_get_fw_73327261
.section .rodata
.Laot_word_name_465:
  .byte 58
  .byte 115
  .byte 50
  .byte 114
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_465:
  .quad .Laot_word_entry_464
  .quad .Laot_word_name_465
  .quad aot_set_fw_73327261
.section .text
aot_get_fw_73327276:
  leaq reg_fw_73327276(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73327276:
  leaq reg_fw_73327276(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_466:
  .byte 115
  .byte 50
  .byte 114
  .byte 118
  .byte 0
.section .data
.Laot_word_entry_466:
  .quad .Laot_word_entry_465
  .quad .Laot_word_name_466
  .quad aot_get_fw_73327276
.section .rodata
.Laot_word_name_467:
  .byte 58
  .byte 115
  .byte 50
  .byte 114
  .byte 118
  .byte 0
.section .data
.Laot_word_entry_467:
  .quad .Laot_word_entry_466
  .quad .Laot_word_name_467
  .quad aot_set_fw_73327276
.section .text
aot_get_fw_73327269:
  leaq reg_fw_73327269(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73327269:
  leaq reg_fw_73327269(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_468:
  .byte 115
  .byte 50
  .byte 114
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_468:
  .quad .Laot_word_entry_467
  .quad .Laot_word_name_468
  .quad aot_get_fw_73327269
.section .rodata
.Laot_word_name_469:
  .byte 58
  .byte 115
  .byte 50
  .byte 114
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_469:
  .quad .Laot_word_entry_468
  .quad .Laot_word_name_469
  .quad aot_set_fw_73327269
.section .text
aot_get_fw_73326374726c61646472:
  leaq reg_fw_73326374726c61646472(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73326374726c61646472:
  leaq reg_fw_73326374726c61646472(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_470:
  .byte 115
  .byte 50
  .byte 99
  .byte 116
  .byte 114
  .byte 108
  .byte 97
  .byte 100
  .byte 100
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_470:
  .quad .Laot_word_entry_469
  .quad .Laot_word_name_470
  .quad aot_get_fw_73326374726c61646472
.section .rodata
.Laot_word_name_471:
  .byte 58
  .byte 115
  .byte 50
  .byte 99
  .byte 116
  .byte 114
  .byte 108
  .byte 97
  .byte 100
  .byte 100
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_471:
  .quad .Laot_word_entry_470
  .quad .Laot_word_name_471
  .quad aot_set_fw_73326374726c61646472
.section .text
aot_get_fw_73326374726c746167:
  leaq reg_fw_73326374726c746167(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73326374726c746167:
  leaq reg_fw_73326374726c746167(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_472:
  .byte 115
  .byte 50
  .byte 99
  .byte 116
  .byte 114
  .byte 108
  .byte 116
  .byte 97
  .byte 103
  .byte 0
.section .data
.Laot_word_entry_472:
  .quad .Laot_word_entry_471
  .quad .Laot_word_name_472
  .quad aot_get_fw_73326374726c746167
.section .rodata
.Laot_word_name_473:
  .byte 58
  .byte 115
  .byte 50
  .byte 99
  .byte 116
  .byte 114
  .byte 108
  .byte 116
  .byte 97
  .byte 103
  .byte 0
.section .data
.Laot_word_entry_473:
  .quad .Laot_word_entry_472
  .quad .Laot_word_name_473
  .quad aot_set_fw_73326374726c746167
.section .text
aot_get_fw_73326672616d65:
  leaq reg_fw_73326672616d65(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73326672616d65:
  leaq reg_fw_73326672616d65(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_474:
  .byte 115
  .byte 50
  .byte 102
  .byte 114
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_474:
  .quad .Laot_word_entry_473
  .quad .Laot_word_name_474
  .quad aot_get_fw_73326672616d65
.section .rodata
.Laot_word_name_475:
  .byte 58
  .byte 115
  .byte 50
  .byte 102
  .byte 114
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_475:
  .quad .Laot_word_entry_474
  .quad .Laot_word_name_475
  .quad aot_set_fw_73326672616d65
.section .text
aot_get_fw_73327370:
  leaq reg_fw_73327370(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73327370:
  leaq reg_fw_73327370(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_476:
  .byte 115
  .byte 50
  .byte 115
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_476:
  .quad .Laot_word_entry_475
  .quad .Laot_word_name_476
  .quad aot_get_fw_73327370
.section .rodata
.Laot_word_name_477:
  .byte 58
  .byte 115
  .byte 50
  .byte 115
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_477:
  .quad .Laot_word_entry_476
  .quad .Laot_word_name_477
  .quad aot_set_fw_73327370
.section .text
aot_get_fw_733274617267657461646472:
  leaq reg_fw_733274617267657461646472(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_733274617267657461646472:
  leaq reg_fw_733274617267657461646472(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_478:
  .byte 115
  .byte 50
  .byte 116
  .byte 97
  .byte 114
  .byte 103
  .byte 101
  .byte 116
  .byte 97
  .byte 100
  .byte 100
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_478:
  .quad .Laot_word_entry_477
  .quad .Laot_word_name_478
  .quad aot_get_fw_733274617267657461646472
.section .rodata
.Laot_word_name_479:
  .byte 58
  .byte 115
  .byte 50
  .byte 116
  .byte 97
  .byte 114
  .byte 103
  .byte 101
  .byte 116
  .byte 97
  .byte 100
  .byte 100
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_479:
  .quad .Laot_word_entry_478
  .quad .Laot_word_name_479
  .quad aot_set_fw_733274617267657461646472
.section .text
aot_get_fw_7332706174636861646472:
  leaq reg_fw_7332706174636861646472(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7332706174636861646472:
  leaq reg_fw_7332706174636861646472(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_480:
  .byte 115
  .byte 50
  .byte 112
  .byte 97
  .byte 116
  .byte 99
  .byte 104
  .byte 97
  .byte 100
  .byte 100
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_480:
  .quad .Laot_word_entry_479
  .quad .Laot_word_name_480
  .quad aot_get_fw_7332706174636861646472
.section .rodata
.Laot_word_name_481:
  .byte 58
  .byte 115
  .byte 50
  .byte 112
  .byte 97
  .byte 116
  .byte 99
  .byte 104
  .byte 97
  .byte 100
  .byte 100
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_481:
  .quad .Laot_word_entry_480
  .quad .Laot_word_name_481
  .quad aot_set_fw_7332706174636861646472
.section .text
aot_get_fw_733264697370:
  leaq reg_fw_733264697370(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_733264697370:
  leaq reg_fw_733264697370(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_482:
  .byte 115
  .byte 50
  .byte 100
  .byte 105
  .byte 115
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_482:
  .quad .Laot_word_entry_481
  .quad .Laot_word_name_482
  .quad aot_get_fw_733264697370
.section .rodata
.Laot_word_name_483:
  .byte 58
  .byte 115
  .byte 50
  .byte 100
  .byte 105
  .byte 115
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_483:
  .quad .Laot_word_entry_482
  .quad .Laot_word_name_483
  .quad aot_set_fw_733264697370
.section .text
aot_get_fw_7332706174636869:
  leaq reg_fw_7332706174636869(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7332706174636869:
  leaq reg_fw_7332706174636869(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_484:
  .byte 115
  .byte 50
  .byte 112
  .byte 97
  .byte 116
  .byte 99
  .byte 104
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_484:
  .quad .Laot_word_entry_483
  .quad .Laot_word_name_484
  .quad aot_get_fw_7332706174636869
.section .rodata
.Laot_word_name_485:
  .byte 58
  .byte 115
  .byte 50
  .byte 112
  .byte 97
  .byte 116
  .byte 99
  .byte 104
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_485:
  .quad .Laot_word_entry_484
  .quad .Laot_word_name_485
  .quad aot_set_fw_7332706174636869
.section .text
aot_get_fw_73326a6d7061646472:
  leaq reg_fw_73326a6d7061646472(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73326a6d7061646472:
  leaq reg_fw_73326a6d7061646472(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_486:
  .byte 115
  .byte 50
  .byte 106
  .byte 109
  .byte 112
  .byte 97
  .byte 100
  .byte 100
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_486:
  .quad .Laot_word_entry_485
  .quad .Laot_word_name_486
  .quad aot_get_fw_73326a6d7061646472
.section .rodata
.Laot_word_name_487:
  .byte 58
  .byte 115
  .byte 50
  .byte 106
  .byte 109
  .byte 112
  .byte 97
  .byte 100
  .byte 100
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_487:
  .quad .Laot_word_entry_486
  .quad .Laot_word_name_487
  .quad aot_set_fw_73326a6d7061646472
.section .text
aot_get_fw_73326f70636f6465:
  leaq reg_fw_73326f70636f6465(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73326f70636f6465:
  leaq reg_fw_73326f70636f6465(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_488:
  .byte 115
  .byte 50
  .byte 111
  .byte 112
  .byte 99
  .byte 111
  .byte 100
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_488:
  .quad .Laot_word_entry_487
  .quad .Laot_word_name_488
  .quad aot_get_fw_73326f70636f6465
.section .rodata
.Laot_word_name_489:
  .byte 58
  .byte 115
  .byte 50
  .byte 111
  .byte 112
  .byte 99
  .byte 111
  .byte 100
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_489:
  .quad .Laot_word_entry_488
  .quad .Laot_word_name_489
  .quad aot_set_fw_73326f70636f6465
.section .text
aot_get_fw_733263746f6b656e:
  leaq reg_fw_733263746f6b656e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_733263746f6b656e:
  leaq reg_fw_733263746f6b656e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_490:
  .byte 115
  .byte 50
  .byte 99
  .byte 116
  .byte 111
  .byte 107
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_490:
  .quad .Laot_word_entry_489
  .quad .Laot_word_name_490
  .quad aot_get_fw_733263746f6b656e
.section .rodata
.Laot_word_name_491:
  .byte 58
  .byte 115
  .byte 50
  .byte 99
  .byte 116
  .byte 111
  .byte 107
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_491:
  .quad .Laot_word_entry_490
  .quad .Laot_word_name_491
  .quad aot_set_fw_733263746f6b656e
.section .text
aot_get_fw_73326f6c64706f73:
  leaq reg_fw_73326f6c64706f73(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73326f6c64706f73:
  leaq reg_fw_73326f6c64706f73(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_492:
  .byte 115
  .byte 50
  .byte 111
  .byte 108
  .byte 100
  .byte 112
  .byte 111
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_492:
  .quad .Laot_word_entry_491
  .quad .Laot_word_name_492
  .quad aot_get_fw_73326f6c64706f73
.section .rodata
.Laot_word_name_493:
  .byte 58
  .byte 115
  .byte 50
  .byte 111
  .byte 108
  .byte 100
  .byte 112
  .byte 111
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_493:
  .quad .Laot_word_entry_492
  .quad .Laot_word_name_493
  .quad aot_set_fw_73326f6c64706f73
.section .text
aot_get_fw_73326f6c64746167:
  leaq reg_fw_73326f6c64746167(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73326f6c64746167:
  leaq reg_fw_73326f6c64746167(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_494:
  .byte 115
  .byte 50
  .byte 111
  .byte 108
  .byte 100
  .byte 116
  .byte 97
  .byte 103
  .byte 0
.section .data
.Laot_word_entry_494:
  .quad .Laot_word_entry_493
  .quad .Laot_word_name_494
  .quad aot_get_fw_73326f6c64746167
.section .rodata
.Laot_word_name_495:
  .byte 58
  .byte 115
  .byte 50
  .byte 111
  .byte 108
  .byte 100
  .byte 116
  .byte 97
  .byte 103
  .byte 0
.section .data
.Laot_word_entry_495:
  .quad .Laot_word_entry_494
  .quad .Laot_word_name_495
  .quad aot_set_fw_73326f6c64746167
.section .text
aot_get_fw_7332656c7365706f73:
  leaq reg_fw_7332656c7365706f73(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7332656c7365706f73:
  leaq reg_fw_7332656c7365706f73(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_496:
  .byte 115
  .byte 50
  .byte 101
  .byte 108
  .byte 115
  .byte 101
  .byte 112
  .byte 111
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_496:
  .quad .Laot_word_entry_495
  .quad .Laot_word_name_496
  .quad aot_get_fw_7332656c7365706f73
.section .rodata
.Laot_word_name_497:
  .byte 58
  .byte 115
  .byte 50
  .byte 101
  .byte 108
  .byte 115
  .byte 101
  .byte 112
  .byte 111
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_497:
  .quad .Laot_word_entry_496
  .quad .Laot_word_name_497
  .quad aot_set_fw_7332656c7365706f73
.section .text
aot_get_fw_73327768696c65706f73:
  leaq reg_fw_73327768696c65706f73(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73327768696c65706f73:
  leaq reg_fw_73327768696c65706f73(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_498:
  .byte 115
  .byte 50
  .byte 119
  .byte 104
  .byte 105
  .byte 108
  .byte 101
  .byte 112
  .byte 111
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_498:
  .quad .Laot_word_entry_497
  .quad .Laot_word_name_498
  .quad aot_get_fw_73327768696c65706f73
.section .rodata
.Laot_word_name_499:
  .byte 58
  .byte 115
  .byte 50
  .byte 119
  .byte 104
  .byte 105
  .byte 108
  .byte 101
  .byte 112
  .byte 111
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_499:
  .quad .Laot_word_entry_498
  .quad .Laot_word_name_499
  .quad aot_set_fw_73327768696c65706f73
.section .text
aot_get_fw_7332737472:
  leaq reg_fw_7332737472(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7332737472:
  leaq reg_fw_7332737472(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_500:
  .byte 115
  .byte 50
  .byte 115
  .byte 116
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_500:
  .quad .Laot_word_entry_499
  .quad .Laot_word_name_500
  .quad aot_get_fw_7332737472
.section .rodata
.Laot_word_name_501:
  .byte 58
  .byte 115
  .byte 50
  .byte 115
  .byte 116
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_501:
  .quad .Laot_word_entry_500
  .quad .Laot_word_name_501
  .quad aot_set_fw_7332737472
.section .text
aot_get_fw_7332696e6e6572:
  leaq reg_fw_7332696e6e6572(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7332696e6e6572:
  leaq reg_fw_7332696e6e6572(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_502:
  .byte 115
  .byte 50
  .byte 105
  .byte 110
  .byte 110
  .byte 101
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_502:
  .quad .Laot_word_entry_501
  .quad .Laot_word_name_502
  .quad aot_get_fw_7332696e6e6572
.section .rodata
.Laot_word_name_503:
  .byte 58
  .byte 115
  .byte 50
  .byte 105
  .byte 110
  .byte 110
  .byte 101
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_503:
  .quad .Laot_word_entry_502
  .quad .Laot_word_name_503
  .quad aot_set_fw_7332696e6e6572
.section .text
aot_get_fw_73327363616e:
  leaq reg_fw_73327363616e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73327363616e:
  leaq reg_fw_73327363616e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_504:
  .byte 115
  .byte 50
  .byte 115
  .byte 99
  .byte 97
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_504:
  .quad .Laot_word_entry_503
  .quad .Laot_word_name_504
  .quad aot_get_fw_73327363616e
.section .rodata
.Laot_word_name_505:
  .byte 58
  .byte 115
  .byte 50
  .byte 115
  .byte 99
  .byte 97
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_505:
  .quad .Laot_word_entry_504
  .quad .Laot_word_name_505
  .quad aot_set_fw_73327363616e
.section .text
aot_get_fw_73326f776e6564:
  leaq reg_fw_73326f776e6564(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73326f776e6564:
  leaq reg_fw_73326f776e6564(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_506:
  .byte 115
  .byte 50
  .byte 111
  .byte 119
  .byte 110
  .byte 101
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_506:
  .quad .Laot_word_entry_505
  .quad .Laot_word_name_506
  .quad aot_get_fw_73326f776e6564
.section .rodata
.Laot_word_name_507:
  .byte 58
  .byte 115
  .byte 50
  .byte 111
  .byte 119
  .byte 110
  .byte 101
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_507:
  .quad .Laot_word_entry_506
  .quad .Laot_word_name_507
  .quad aot_set_fw_73326f776e6564
.section .text
aot_get_fw_7332746f6b656e:
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7332746f6b656e:
  leaq reg_fw_7332746f6b656e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_508:
  .byte 115
  .byte 50
  .byte 116
  .byte 111
  .byte 107
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_508:
  .quad .Laot_word_entry_507
  .quad .Laot_word_name_508
  .quad aot_get_fw_7332746f6b656e
.section .rodata
.Laot_word_name_509:
  .byte 58
  .byte 115
  .byte 50
  .byte 116
  .byte 111
  .byte 107
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_509:
  .quad .Laot_word_entry_508
  .quad .Laot_word_name_509
  .quad aot_set_fw_7332746f6b656e
.section .text
aot_get_fw_7332746172676574:
  leaq reg_fw_7332746172676574(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7332746172676574:
  leaq reg_fw_7332746172676574(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_510:
  .byte 115
  .byte 50
  .byte 116
  .byte 97
  .byte 114
  .byte 103
  .byte 101
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_510:
  .quad .Laot_word_entry_509
  .quad .Laot_word_name_510
  .quad aot_get_fw_7332746172676574
.section .rodata
.Laot_word_name_511:
  .byte 58
  .byte 115
  .byte 50
  .byte 116
  .byte 97
  .byte 114
  .byte 103
  .byte 101
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_511:
  .quad .Laot_word_entry_510
  .quad .Laot_word_name_511
  .quad aot_set_fw_7332746172676574
.section .text
aot_get_fw_733271756f746561646472:
  leaq reg_fw_733271756f746561646472(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_733271756f746561646472:
  leaq reg_fw_733271756f746561646472(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_512:
  .byte 115
  .byte 50
  .byte 113
  .byte 117
  .byte 111
  .byte 116
  .byte 101
  .byte 97
  .byte 100
  .byte 100
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_512:
  .quad .Laot_word_entry_511
  .quad .Laot_word_name_512
  .quad aot_get_fw_733271756f746561646472
.section .rodata
.Laot_word_name_513:
  .byte 58
  .byte 115
  .byte 50
  .byte 113
  .byte 117
  .byte 111
  .byte 116
  .byte 101
  .byte 97
  .byte 100
  .byte 100
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_513:
  .quad .Laot_word_entry_512
  .quad .Laot_word_name_513
  .quad aot_set_fw_733271756f746561646472
.section .text
aot_get_fw_733276616c6964:
  leaq reg_fw_733276616c6964(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_733276616c6964:
  leaq reg_fw_733276616c6964(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_514:
  .byte 115
  .byte 50
  .byte 118
  .byte 97
  .byte 108
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_514:
  .quad .Laot_word_entry_513
  .quad .Laot_word_name_514
  .quad aot_get_fw_733276616c6964
.section .rodata
.Laot_word_name_515:
  .byte 58
  .byte 115
  .byte 50
  .byte 118
  .byte 97
  .byte 108
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_515:
  .quad .Laot_word_entry_514
  .quad .Laot_word_name_515
  .quad aot_set_fw_733276616c6964
.section .text
aot_get_fw_733264656e76616c32:
  leaq reg_fw_733264656e76616c32(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_733264656e76616c32:
  leaq reg_fw_733264656e76616c32(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_516:
  .byte 115
  .byte 50
  .byte 100
  .byte 101
  .byte 110
  .byte 118
  .byte 97
  .byte 108
  .byte 50
  .byte 0
.section .data
.Laot_word_entry_516:
  .quad .Laot_word_entry_515
  .quad .Laot_word_name_516
  .quad aot_get_fw_733264656e76616c32
.section .rodata
.Laot_word_name_517:
  .byte 58
  .byte 115
  .byte 50
  .byte 100
  .byte 101
  .byte 110
  .byte 118
  .byte 97
  .byte 108
  .byte 50
  .byte 0
.section .data
.Laot_word_entry_517:
  .quad .Laot_word_entry_516
  .quad .Laot_word_name_517
  .quad aot_set_fw_733264656e76616c32
.section .text
aot_get_fw_73326c697476616c:
  leaq reg_fw_73326c697476616c(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73326c697476616c:
  leaq reg_fw_73326c697476616c(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_518:
  .byte 115
  .byte 50
  .byte 108
  .byte 105
  .byte 116
  .byte 118
  .byte 97
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_518:
  .quad .Laot_word_entry_517
  .quad .Laot_word_name_518
  .quad aot_get_fw_73326c697476616c
.section .rodata
.Laot_word_name_519:
  .byte 58
  .byte 115
  .byte 50
  .byte 108
  .byte 105
  .byte 116
  .byte 118
  .byte 97
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_519:
  .quad .Laot_word_entry_518
  .quad .Laot_word_name_519
  .quad aot_set_fw_73326c697476616c
.section .text
aot_get_fw_73326465666d6f6465:
  leaq reg_fw_73326465666d6f6465(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73326465666d6f6465:
  leaq reg_fw_73326465666d6f6465(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_520:
  .byte 115
  .byte 50
  .byte 100
  .byte 101
  .byte 102
  .byte 109
  .byte 111
  .byte 100
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_520:
  .quad .Laot_word_entry_519
  .quad .Laot_word_name_520
  .quad aot_get_fw_73326465666d6f6465
.section .rodata
.Laot_word_name_521:
  .byte 58
  .byte 115
  .byte 50
  .byte 100
  .byte 101
  .byte 102
  .byte 109
  .byte 111
  .byte 100
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_521:
  .quad .Laot_word_entry_520
  .quad .Laot_word_name_521
  .quad aot_set_fw_73326465666d6f6465
.section .text
aot_get_fw_7332626567696e:
  leaq reg_fw_7332626567696e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7332626567696e:
  leaq reg_fw_7332626567696e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_522:
  .byte 115
  .byte 50
  .byte 98
  .byte 101
  .byte 103
  .byte 105
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_522:
  .quad .Laot_word_entry_521
  .quad .Laot_word_name_522
  .quad aot_get_fw_7332626567696e
.section .rodata
.Laot_word_name_523:
  .byte 58
  .byte 115
  .byte 50
  .byte 98
  .byte 101
  .byte 103
  .byte 105
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_523:
  .quad .Laot_word_entry_522
  .quad .Laot_word_name_523
  .quad aot_set_fw_7332626567696e
.section .text
aot_get_fw_7332647374:
  leaq reg_fw_7332647374(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7332647374:
  leaq reg_fw_7332647374(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_524:
  .byte 115
  .byte 50
  .byte 100
  .byte 115
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_524:
  .quad .Laot_word_entry_523
  .quad .Laot_word_name_524
  .quad aot_get_fw_7332647374
.section .rodata
.Laot_word_name_525:
  .byte 58
  .byte 115
  .byte 50
  .byte 100
  .byte 115
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_525:
  .quad .Laot_word_entry_524
  .quad .Laot_word_name_525
  .quad aot_set_fw_7332647374
.section .text
aot_get_fw_73326c696e652d6c656e:
  leaq reg_fw_73326c696e652d6c656e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73326c696e652d6c656e:
  leaq reg_fw_73326c696e652d6c656e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_526:
  .byte 115
  .byte 50
  .byte 108
  .byte 105
  .byte 110
  .byte 101
  .byte 45
  .byte 108
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_526:
  .quad .Laot_word_entry_525
  .quad .Laot_word_name_526
  .quad aot_get_fw_73326c696e652d6c656e
.section .rodata
.Laot_word_name_527:
  .byte 58
  .byte 115
  .byte 50
  .byte 108
  .byte 105
  .byte 110
  .byte 101
  .byte 45
  .byte 108
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_527:
  .quad .Laot_word_entry_526
  .quad .Laot_word_name_527
  .quad aot_set_fw_73326c696e652d6c656e
.section .text
aot_get_fw_73327363686172:
  leaq reg_fw_73327363686172(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73327363686172:
  leaq reg_fw_73327363686172(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_528:
  .byte 115
  .byte 50
  .byte 115
  .byte 99
  .byte 104
  .byte 97
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_528:
  .quad .Laot_word_entry_527
  .quad .Laot_word_name_528
  .quad aot_get_fw_73327363686172
.section .rodata
.Laot_word_name_529:
  .byte 58
  .byte 115
  .byte 50
  .byte 115
  .byte 99
  .byte 104
  .byte 97
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_529:
  .quad .Laot_word_entry_528
  .quad .Laot_word_name_529
  .quad aot_set_fw_73327363686172
.section .text
aot_get_fw_733273726369:
  leaq reg_fw_733273726369(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_733273726369:
  leaq reg_fw_733273726369(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_530:
  .byte 115
  .byte 50
  .byte 115
  .byte 114
  .byte 99
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_530:
  .quad .Laot_word_entry_529
  .quad .Laot_word_name_530
  .quad aot_get_fw_733273726369
.section .rodata
.Laot_word_name_531:
  .byte 58
  .byte 115
  .byte 50
  .byte 115
  .byte 114
  .byte 99
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_531:
  .quad .Laot_word_entry_530
  .quad .Laot_word_name_531
  .quad aot_set_fw_733273726369
.section .text
aot_get_fw_73326c696e6573:
  leaq reg_fw_73326c696e6573(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73326c696e6573:
  leaq reg_fw_73326c696e6573(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_532:
  .byte 115
  .byte 50
  .byte 108
  .byte 105
  .byte 110
  .byte 101
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_532:
  .quad .Laot_word_entry_531
  .quad .Laot_word_name_532
  .quad aot_get_fw_73326c696e6573
.section .rodata
.Laot_word_name_533:
  .byte 58
  .byte 115
  .byte 50
  .byte 108
  .byte 105
  .byte 110
  .byte 101
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_533:
  .quad .Laot_word_entry_532
  .quad .Laot_word_name_533
  .quad aot_set_fw_73326c696e6573
.section .text
aot_get_fw_7332657869737473:
  leaq reg_fw_7332657869737473(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7332657869737473:
  leaq reg_fw_7332657869737473(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_534:
  .byte 115
  .byte 50
  .byte 101
  .byte 120
  .byte 105
  .byte 115
  .byte 116
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_534:
  .quad .Laot_word_entry_533
  .quad .Laot_word_name_534
  .quad aot_get_fw_7332657869737473
.section .rodata
.Laot_word_name_535:
  .byte 58
  .byte 115
  .byte 50
  .byte 101
  .byte 120
  .byte 105
  .byte 115
  .byte 116
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_535:
  .quad .Laot_word_entry_534
  .quad .Laot_word_name_535
  .quad aot_set_fw_7332657869737473
.section .text
aot_get_fw_73326669727374:
  leaq reg_fw_73326669727374(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73326669727374:
  leaq reg_fw_73326669727374(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_536:
  .byte 115
  .byte 50
  .byte 102
  .byte 105
  .byte 114
  .byte 115
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_536:
  .quad .Laot_word_entry_535
  .quad .Laot_word_name_536
  .quad aot_get_fw_73326669727374
.section .rodata
.Laot_word_name_537:
  .byte 58
  .byte 115
  .byte 50
  .byte 102
  .byte 105
  .byte 114
  .byte 115
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_537:
  .quad .Laot_word_entry_536
  .quad .Laot_word_name_537
  .quad aot_set_fw_73326669727374
.section .text
aot_get_fw_73326576616c2d74657874:
  leaq reg_fw_73326576616c2d74657874(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73326576616c2d74657874:
  leaq reg_fw_73326576616c2d74657874(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_538:
  .byte 115
  .byte 50
  .byte 101
  .byte 118
  .byte 97
  .byte 108
  .byte 45
  .byte 116
  .byte 101
  .byte 120
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_538:
  .quad .Laot_word_entry_537
  .quad .Laot_word_name_538
  .quad aot_get_fw_73326576616c2d74657874
.section .rodata
.Laot_word_name_539:
  .byte 58
  .byte 115
  .byte 50
  .byte 101
  .byte 118
  .byte 97
  .byte 108
  .byte 45
  .byte 116
  .byte 101
  .byte 120
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_539:
  .quad .Laot_word_entry_538
  .quad .Laot_word_name_539
  .quad aot_set_fw_73326576616c2d74657874
.section .text
aot_get_fw_73326576616c2d646566:
  leaq reg_fw_73326576616c2d646566(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73326576616c2d646566:
  leaq reg_fw_73326576616c2d646566(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_540:
  .byte 115
  .byte 50
  .byte 101
  .byte 118
  .byte 97
  .byte 108
  .byte 45
  .byte 100
  .byte 101
  .byte 102
  .byte 0
.section .data
.Laot_word_entry_540:
  .quad .Laot_word_entry_539
  .quad .Laot_word_name_540
  .quad aot_get_fw_73326576616c2d646566
.section .rodata
.Laot_word_name_541:
  .byte 58
  .byte 115
  .byte 50
  .byte 101
  .byte 118
  .byte 97
  .byte 108
  .byte 45
  .byte 100
  .byte 101
  .byte 102
  .byte 0
.section .data
.Laot_word_entry_541:
  .quad .Laot_word_entry_540
  .quad .Laot_word_name_541
  .quad aot_set_fw_73326576616c2d646566
.section .text
aot_get_fw_73326576616c2d636f6465:
  leaq reg_fw_73326576616c2d636f6465(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73326576616c2d636f6465:
  leaq reg_fw_73326576616c2d636f6465(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_542:
  .byte 115
  .byte 50
  .byte 101
  .byte 118
  .byte 97
  .byte 108
  .byte 45
  .byte 99
  .byte 111
  .byte 100
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_542:
  .quad .Laot_word_entry_541
  .quad .Laot_word_name_542
  .quad aot_get_fw_73326576616c2d636f6465
.section .rodata
.Laot_word_name_543:
  .byte 58
  .byte 115
  .byte 50
  .byte 101
  .byte 118
  .byte 97
  .byte 108
  .byte 45
  .byte 99
  .byte 111
  .byte 100
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_543:
  .quad .Laot_word_entry_542
  .quad .Laot_word_name_543
  .quad aot_set_fw_73326576616c2d636f6465
.section .text
aot_get_fw_726c2d6c656e:
  leaq reg_fw_726c2d6c656e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_726c2d6c656e:
  leaq reg_fw_726c2d6c656e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_544:
  .byte 114
  .byte 108
  .byte 45
  .byte 108
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_544:
  .quad .Laot_word_entry_543
  .quad .Laot_word_name_544
  .quad aot_get_fw_726c2d6c656e
.section .rodata
.Laot_word_name_545:
  .byte 58
  .byte 114
  .byte 108
  .byte 45
  .byte 108
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_545:
  .quad .Laot_word_entry_544
  .quad .Laot_word_name_545
  .quad aot_set_fw_726c2d6c656e
.section .text
aot_get_fw_726c2d6368:
  leaq reg_fw_726c2d6368(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_726c2d6368:
  leaq reg_fw_726c2d6368(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_546:
  .byte 114
  .byte 108
  .byte 45
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_546:
  .quad .Laot_word_entry_545
  .quad .Laot_word_name_546
  .quad aot_get_fw_726c2d6368
.section .rodata
.Laot_word_name_547:
  .byte 58
  .byte 114
  .byte 108
  .byte 45
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_547:
  .quad .Laot_word_entry_546
  .quad .Laot_word_name_547
  .quad aot_set_fw_726c2d6368
.section .text
aot_get_fw_726c2d6265666f7265:
  leaq reg_fw_726c2d6265666f7265(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_726c2d6265666f7265:
  leaq reg_fw_726c2d6265666f7265(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_548:
  .byte 114
  .byte 108
  .byte 45
  .byte 98
  .byte 101
  .byte 102
  .byte 111
  .byte 114
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_548:
  .quad .Laot_word_entry_547
  .quad .Laot_word_name_548
  .quad aot_get_fw_726c2d6265666f7265
.section .rodata
.Laot_word_name_549:
  .byte 58
  .byte 114
  .byte 108
  .byte 45
  .byte 98
  .byte 101
  .byte 102
  .byte 111
  .byte 114
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_549:
  .quad .Laot_word_entry_548
  .quad .Laot_word_name_549
  .quad aot_set_fw_726c2d6265666f7265
.section .text
aot_get_fw_75672d736f75726365:
  leaq reg_fw_75672d736f75726365(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_75672d736f75726365:
  leaq reg_fw_75672d736f75726365(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_550:
  .byte 117
  .byte 103
  .byte 45
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_550:
  .quad .Laot_word_entry_549
  .quad .Laot_word_name_550
  .quad aot_get_fw_75672d736f75726365
.section .rodata
.Laot_word_name_551:
  .byte 58
  .byte 117
  .byte 103
  .byte 45
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_551:
  .quad .Laot_word_entry_550
  .quad .Laot_word_name_551
  .quad aot_set_fw_75672d736f75726365
.section .text
aot_get_fw_75672d6265666f7265:
  leaq reg_fw_75672d6265666f7265(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_75672d6265666f7265:
  leaq reg_fw_75672d6265666f7265(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_552:
  .byte 117
  .byte 103
  .byte 45
  .byte 98
  .byte 101
  .byte 102
  .byte 111
  .byte 114
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_552:
  .quad .Laot_word_entry_551
  .quad .Laot_word_name_552
  .quad aot_get_fw_75672d6265666f7265
.section .rodata
.Laot_word_name_553:
  .byte 58
  .byte 117
  .byte 103
  .byte 45
  .byte 98
  .byte 101
  .byte 102
  .byte 111
  .byte 114
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_553:
  .quad .Laot_word_entry_552
  .quad .Laot_word_name_553
  .quad aot_set_fw_75672d6265666f7265
.section .text
aot_get_fw_75672d6166746572:
  leaq reg_fw_75672d6166746572(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_75672d6166746572:
  leaq reg_fw_75672d6166746572(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_554:
  .byte 117
  .byte 103
  .byte 45
  .byte 97
  .byte 102
  .byte 116
  .byte 101
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_554:
  .quad .Laot_word_entry_553
  .quad .Laot_word_name_554
  .quad aot_get_fw_75672d6166746572
.section .rodata
.Laot_word_name_555:
  .byte 58
  .byte 117
  .byte 103
  .byte 45
  .byte 97
  .byte 102
  .byte 116
  .byte 101
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_555:
  .quad .Laot_word_entry_554
  .quad .Laot_word_name_555
  .quad aot_set_fw_75672d6166746572
.section .text
aot_get_fw_61642d6e:
  leaq reg_fw_61642d6e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61642d6e:
  leaq reg_fw_61642d6e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_556:
  .byte 97
  .byte 100
  .byte 45
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_556:
  .quad .Laot_word_entry_555
  .quad .Laot_word_name_556
  .quad aot_get_fw_61642d6e
.section .rodata
.Laot_word_name_557:
  .byte 58
  .byte 97
  .byte 100
  .byte 45
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_557:
  .quad .Laot_word_entry_556
  .quad .Laot_word_name_557
  .quad aot_set_fw_61642d6e
.section .text
aot_get_fw_61642d7374617274:
  leaq reg_fw_61642d7374617274(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61642d7374617274:
  leaq reg_fw_61642d7374617274(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_558:
  .byte 97
  .byte 100
  .byte 45
  .byte 115
  .byte 116
  .byte 97
  .byte 114
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_558:
  .quad .Laot_word_entry_557
  .quad .Laot_word_name_558
  .quad aot_get_fw_61642d7374617274
.section .rodata
.Laot_word_name_559:
  .byte 58
  .byte 97
  .byte 100
  .byte 45
  .byte 115
  .byte 116
  .byte 97
  .byte 114
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_559:
  .quad .Laot_word_entry_558
  .quad .Laot_word_name_559
  .quad aot_set_fw_61642d7374617274
.section .text
aot_get_fw_61642d706c616365:
  leaq reg_fw_61642d706c616365(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61642d706c616365:
  leaq reg_fw_61642d706c616365(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_560:
  .byte 97
  .byte 100
  .byte 45
  .byte 112
  .byte 108
  .byte 97
  .byte 99
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_560:
  .quad .Laot_word_entry_559
  .quad .Laot_word_name_560
  .quad aot_get_fw_61642d706c616365
.section .rodata
.Laot_word_name_561:
  .byte 58
  .byte 97
  .byte 100
  .byte 45
  .byte 112
  .byte 108
  .byte 97
  .byte 99
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_561:
  .quad .Laot_word_entry_560
  .quad .Laot_word_name_561
  .quad aot_set_fw_61642d706c616365
.section .text
aot_get_fw_61642d6469676974:
  leaq reg_fw_61642d6469676974(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61642d6469676974:
  leaq reg_fw_61642d6469676974(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_562:
  .byte 97
  .byte 100
  .byte 45
  .byte 100
  .byte 105
  .byte 103
  .byte 105
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_562:
  .quad .Laot_word_entry_561
  .quad .Laot_word_name_562
  .quad aot_get_fw_61642d6469676974
.section .rodata
.Laot_word_name_563:
  .byte 58
  .byte 97
  .byte 100
  .byte 45
  .byte 100
  .byte 105
  .byte 103
  .byte 105
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_563:
  .quad .Laot_word_entry_562
  .quad .Laot_word_name_563
  .quad aot_set_fw_61642d6469676974
.section .text
aot_get_fw_61732d6e:
  leaq reg_fw_61732d6e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61732d6e:
  leaq reg_fw_61732d6e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_564:
  .byte 97
  .byte 115
  .byte 45
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_564:
  .quad .Laot_word_entry_563
  .quad .Laot_word_name_564
  .quad aot_get_fw_61732d6e
.section .rodata
.Laot_word_name_565:
  .byte 58
  .byte 97
  .byte 115
  .byte 45
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_565:
  .quad .Laot_word_entry_564
  .quad .Laot_word_name_565
  .quad aot_set_fw_61732d6e
.section .text
aot_get_fw_61662d76:
  leaq reg_fw_61662d76(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61662d76:
  leaq reg_fw_61662d76(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_566:
  .byte 97
  .byte 102
  .byte 45
  .byte 118
  .byte 0
.section .data
.Laot_word_entry_566:
  .quad .Laot_word_entry_565
  .quad .Laot_word_name_566
  .quad aot_get_fw_61662d76
.section .rodata
.Laot_word_name_567:
  .byte 58
  .byte 97
  .byte 102
  .byte 45
  .byte 118
  .byte 0
.section .data
.Laot_word_entry_567:
  .quad .Laot_word_entry_566
  .quad .Laot_word_name_567
  .quad aot_set_fw_61662d76
.section .text
aot_get_fw_616c2d64656e:
  leaq reg_fw_616c2d64656e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_616c2d64656e:
  leaq reg_fw_616c2d64656e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_568:
  .byte 97
  .byte 108
  .byte 45
  .byte 100
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_568:
  .quad .Laot_word_entry_567
  .quad .Laot_word_name_568
  .quad aot_get_fw_616c2d64656e
.section .rodata
.Laot_word_name_569:
  .byte 58
  .byte 97
  .byte 108
  .byte 45
  .byte 100
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_569:
  .quad .Laot_word_entry_568
  .quad .Laot_word_name_569
  .quad aot_set_fw_616c2d64656e
.section .text
aot_get_fw_616c2d6e756d:
  leaq reg_fw_616c2d6e756d(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_616c2d6e756d:
  leaq reg_fw_616c2d6e756d(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_570:
  .byte 97
  .byte 108
  .byte 45
  .byte 110
  .byte 117
  .byte 109
  .byte 0
.section .data
.Laot_word_entry_570:
  .quad .Laot_word_entry_569
  .quad .Laot_word_name_570
  .quad aot_get_fw_616c2d6e756d
.section .rodata
.Laot_word_name_571:
  .byte 58
  .byte 97
  .byte 108
  .byte 45
  .byte 110
  .byte 117
  .byte 109
  .byte 0
.section .data
.Laot_word_entry_571:
  .quad .Laot_word_entry_570
  .quad .Laot_word_name_571
  .quad aot_set_fw_616c2d6e756d
.section .text
aot_get_fw_6166652d6669656c64:
  leaq reg_fw_6166652d6669656c64(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6166652d6669656c64:
  leaq reg_fw_6166652d6669656c64(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_572:
  .byte 97
  .byte 102
  .byte 101
  .byte 45
  .byte 102
  .byte 105
  .byte 101
  .byte 108
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_572:
  .quad .Laot_word_entry_571
  .quad .Laot_word_name_572
  .quad aot_get_fw_6166652d6669656c64
.section .rodata
.Laot_word_name_573:
  .byte 58
  .byte 97
  .byte 102
  .byte 101
  .byte 45
  .byte 102
  .byte 105
  .byte 101
  .byte 108
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_573:
  .quad .Laot_word_entry_572
  .quad .Laot_word_name_573
  .quad aot_set_fw_6166652d6669656c64
.section .text
aot_get_fw_6166652d74657874:
  leaq reg_fw_6166652d74657874(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6166652d74657874:
  leaq reg_fw_6166652d74657874(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_574:
  .byte 97
  .byte 102
  .byte 101
  .byte 45
  .byte 116
  .byte 101
  .byte 120
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_574:
  .quad .Laot_word_entry_573
  .quad .Laot_word_name_574
  .quad aot_get_fw_6166652d74657874
.section .rodata
.Laot_word_name_575:
  .byte 58
  .byte 97
  .byte 102
  .byte 101
  .byte 45
  .byte 116
  .byte 101
  .byte 120
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_575:
  .quad .Laot_word_entry_574
  .quad .Laot_word_name_575
  .quad aot_set_fw_6166652d74657874
.section .text
aot_get_fw_6166652d62:
  leaq reg_fw_6166652d62(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6166652d62:
  leaq reg_fw_6166652d62(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_576:
  .byte 97
  .byte 102
  .byte 101
  .byte 45
  .byte 98
  .byte 0
.section .data
.Laot_word_entry_576:
  .quad .Laot_word_entry_575
  .quad .Laot_word_name_576
  .quad aot_get_fw_6166652d62
.section .rodata
.Laot_word_name_577:
  .byte 58
  .byte 97
  .byte 102
  .byte 101
  .byte 45
  .byte 98
  .byte 0
.section .data
.Laot_word_entry_577:
  .quad .Laot_word_entry_576
  .quad .Laot_word_name_577
  .quad aot_set_fw_6166652d62
.section .text
aot_get_fw_61666e2d706f73:
  leaq reg_fw_61666e2d706f73(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61666e2d706f73:
  leaq reg_fw_61666e2d706f73(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_578:
  .byte 97
  .byte 102
  .byte 110
  .byte 45
  .byte 112
  .byte 111
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_578:
  .quad .Laot_word_entry_577
  .quad .Laot_word_name_578
  .quad aot_get_fw_61666e2d706f73
.section .rodata
.Laot_word_name_579:
  .byte 58
  .byte 97
  .byte 102
  .byte 110
  .byte 45
  .byte 112
  .byte 111
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_579:
  .quad .Laot_word_entry_578
  .quad .Laot_word_name_579
  .quad aot_set_fw_61666e2d706f73
.section .text
aot_get_fw_61666e2d62:
  leaq reg_fw_61666e2d62(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61666e2d62:
  leaq reg_fw_61666e2d62(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_580:
  .byte 97
  .byte 102
  .byte 110
  .byte 45
  .byte 98
  .byte 0
.section .data
.Laot_word_entry_580:
  .quad .Laot_word_entry_579
  .quad .Laot_word_name_580
  .quad aot_get_fw_61666e2d62
.section .rodata
.Laot_word_name_581:
  .byte 58
  .byte 97
  .byte 102
  .byte 110
  .byte 45
  .byte 98
  .byte 0
.section .data
.Laot_word_entry_581:
  .quad .Laot_word_entry_580
  .quad .Laot_word_name_581
  .quad aot_set_fw_61666e2d62
.section .text
aot_get_fw_6170662d706f73:
  leaq reg_fw_6170662d706f73(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6170662d706f73:
  leaq reg_fw_6170662d706f73(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_582:
  .byte 97
  .byte 112
  .byte 102
  .byte 45
  .byte 112
  .byte 111
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_582:
  .quad .Laot_word_entry_581
  .quad .Laot_word_name_582
  .quad aot_get_fw_6170662d706f73
.section .rodata
.Laot_word_name_583:
  .byte 58
  .byte 97
  .byte 112
  .byte 102
  .byte 45
  .byte 112
  .byte 111
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_583:
  .quad .Laot_word_entry_582
  .quad .Laot_word_name_583
  .quad aot_set_fw_6170662d706f73
.section .text
aot_get_fw_6170662d63:
  leaq reg_fw_6170662d63(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6170662d63:
  leaq reg_fw_6170662d63(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_584:
  .byte 97
  .byte 112
  .byte 102
  .byte 45
  .byte 99
  .byte 0
.section .data
.Laot_word_entry_584:
  .quad .Laot_word_entry_583
  .quad .Laot_word_name_584
  .quad aot_get_fw_6170662d63
.section .rodata
.Laot_word_name_585:
  .byte 58
  .byte 97
  .byte 112
  .byte 102
  .byte 45
  .byte 99
  .byte 0
.section .data
.Laot_word_entry_585:
  .quad .Laot_word_entry_584
  .quad .Laot_word_name_585
  .quad aot_set_fw_6170662d63
.section .text
aot_get_fw_616f6d2d706f73:
  leaq reg_fw_616f6d2d706f73(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_616f6d2d706f73:
  leaq reg_fw_616f6d2d706f73(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_586:
  .byte 97
  .byte 111
  .byte 109
  .byte 45
  .byte 112
  .byte 111
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_586:
  .quad .Laot_word_entry_585
  .quad .Laot_word_name_586
  .quad aot_get_fw_616f6d2d706f73
.section .rodata
.Laot_word_name_587:
  .byte 58
  .byte 97
  .byte 111
  .byte 109
  .byte 45
  .byte 112
  .byte 111
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_587:
  .quad .Laot_word_entry_586
  .quad .Laot_word_name_587
  .quad aot_set_fw_616f6d2d706f73
.section .text
aot_get_fw_616f6d2d776f7264:
  leaq reg_fw_616f6d2d776f7264(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_616f6d2d776f7264:
  leaq reg_fw_616f6d2d776f7264(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_588:
  .byte 97
  .byte 111
  .byte 109
  .byte 45
  .byte 119
  .byte 111
  .byte 114
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_588:
  .quad .Laot_word_entry_587
  .quad .Laot_word_name_588
  .quad aot_get_fw_616f6d2d776f7264
.section .rodata
.Laot_word_name_589:
  .byte 58
  .byte 97
  .byte 111
  .byte 109
  .byte 45
  .byte 119
  .byte 111
  .byte 114
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_589:
  .quad .Laot_word_entry_588
  .quad .Laot_word_name_589
  .quad aot_set_fw_616f6d2d776f7264
.section .text
aot_get_fw_616f2d74:
  leaq reg_fw_616f2d74(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_616f2d74:
  leaq reg_fw_616f2d74(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_590:
  .byte 97
  .byte 111
  .byte 45
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_590:
  .quad .Laot_word_entry_589
  .quad .Laot_word_name_590
  .quad aot_get_fw_616f2d74
.section .rodata
.Laot_word_name_591:
  .byte 58
  .byte 97
  .byte 111
  .byte 45
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_591:
  .quad .Laot_word_entry_590
  .quad .Laot_word_name_591
  .quad aot_set_fw_616f2d74
.section .text
aot_get_fw_61742d746f6b656e:
  leaq reg_fw_61742d746f6b656e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61742d746f6b656e:
  leaq reg_fw_61742d746f6b656e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_592:
  .byte 97
  .byte 116
  .byte 45
  .byte 116
  .byte 111
  .byte 107
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_592:
  .quad .Laot_word_entry_591
  .quad .Laot_word_name_592
  .quad aot_get_fw_61742d746f6b656e
.section .rodata
.Laot_word_name_593:
  .byte 58
  .byte 97
  .byte 116
  .byte 45
  .byte 116
  .byte 111
  .byte 107
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_593:
  .quad .Laot_word_entry_592
  .quad .Laot_word_name_593
  .quad aot_set_fw_61742d746f6b656e
.section .text
aot_get_fw_61742d76616c6964:
  leaq reg_fw_61742d76616c6964(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61742d76616c6964:
  leaq reg_fw_61742d76616c6964(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_594:
  .byte 97
  .byte 116
  .byte 45
  .byte 118
  .byte 97
  .byte 108
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_594:
  .quad .Laot_word_entry_593
  .quad .Laot_word_name_594
  .quad aot_get_fw_61742d76616c6964
.section .rodata
.Laot_word_name_595:
  .byte 58
  .byte 97
  .byte 116
  .byte 45
  .byte 118
  .byte 97
  .byte 108
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_595:
  .quad .Laot_word_entry_594
  .quad .Laot_word_name_595
  .quad aot_set_fw_61742d76616c6964
.section .text
aot_get_fw_61742d64656e:
  leaq reg_fw_61742d64656e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61742d64656e:
  leaq reg_fw_61742d64656e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_596:
  .byte 97
  .byte 116
  .byte 45
  .byte 100
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_596:
  .quad .Laot_word_entry_595
  .quad .Laot_word_name_596
  .quad aot_get_fw_61742d64656e
.section .rodata
.Laot_word_name_597:
  .byte 58
  .byte 97
  .byte 116
  .byte 45
  .byte 100
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_597:
  .quad .Laot_word_entry_596
  .quad .Laot_word_name_597
  .quad aot_set_fw_61742d64656e
.section .text
aot_get_fw_61742d6e756d:
  leaq reg_fw_61742d6e756d(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61742d6e756d:
  leaq reg_fw_61742d6e756d(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_598:
  .byte 97
  .byte 116
  .byte 45
  .byte 110
  .byte 117
  .byte 109
  .byte 0
.section .data
.Laot_word_entry_598:
  .quad .Laot_word_entry_597
  .quad .Laot_word_name_598
  .quad aot_get_fw_61742d6e756d
.section .rodata
.Laot_word_name_599:
  .byte 58
  .byte 97
  .byte 116
  .byte 45
  .byte 110
  .byte 117
  .byte 109
  .byte 0
.section .data
.Laot_word_entry_599:
  .quad .Laot_word_entry_598
  .quad .Laot_word_name_599
  .quad aot_set_fw_61742d6e756d
.section .text
aot_get_fw_61742d6e657874:
  leaq reg_fw_61742d6e657874(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61742d6e657874:
  leaq reg_fw_61742d6e657874(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_600:
  .byte 97
  .byte 116
  .byte 45
  .byte 110
  .byte 101
  .byte 120
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_600:
  .quad .Laot_word_entry_599
  .quad .Laot_word_name_600
  .quad aot_get_fw_61742d6e657874
.section .rodata
.Laot_word_name_601:
  .byte 58
  .byte 97
  .byte 116
  .byte 45
  .byte 110
  .byte 101
  .byte 120
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_601:
  .quad .Laot_word_entry_600
  .quad .Laot_word_name_601
  .quad aot_set_fw_61742d6e657874
.section .text
aot_get_fw_616e2d6e:
  leaq reg_fw_616e2d6e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_616e2d6e:
  leaq reg_fw_616e2d6e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_602:
  .byte 97
  .byte 110
  .byte 45
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_602:
  .quad .Laot_word_entry_601
  .quad .Laot_word_name_602
  .quad aot_get_fw_616e2d6e
.section .rodata
.Laot_word_name_603:
  .byte 58
  .byte 97
  .byte 110
  .byte 45
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_603:
  .quad .Laot_word_entry_602
  .quad .Laot_word_name_603
  .quad aot_set_fw_616e2d6e
.section .text
aot_get_fw_616e2d6e616d65:
  leaq reg_fw_616e2d6e616d65(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_616e2d6e616d65:
  leaq reg_fw_616e2d6e616d65(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_604:
  .byte 97
  .byte 110
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_604:
  .quad .Laot_word_entry_603
  .quad .Laot_word_name_604
  .quad aot_get_fw_616e2d6e616d65
.section .rodata
.Laot_word_name_605:
  .byte 58
  .byte 97
  .byte 110
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_605:
  .quad .Laot_word_entry_604
  .quad .Laot_word_name_605
  .quad aot_set_fw_616e2d6e616d65
.section .text
aot_get_fw_616e2d62797465:
  leaq reg_fw_616e2d62797465(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_616e2d62797465:
  leaq reg_fw_616e2d62797465(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_606:
  .byte 97
  .byte 110
  .byte 45
  .byte 98
  .byte 121
  .byte 116
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_606:
  .quad .Laot_word_entry_605
  .quad .Laot_word_name_606
  .quad aot_get_fw_616e2d62797465
.section .rodata
.Laot_word_name_607:
  .byte 58
  .byte 97
  .byte 110
  .byte 45
  .byte 98
  .byte 121
  .byte 116
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_607:
  .quad .Laot_word_entry_606
  .quad .Laot_word_name_607
  .quad aot_set_fw_616e2d62797465
.section .text
aot_get_fw_61632d6e616d65:
  leaq reg_fw_61632d6e616d65(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61632d6e616d65:
  leaq reg_fw_61632d6e616d65(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_608:
  .byte 97
  .byte 99
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_608:
  .quad .Laot_word_entry_607
  .quad .Laot_word_name_608
  .quad aot_get_fw_61632d6e616d65
.section .rodata
.Laot_word_name_609:
  .byte 58
  .byte 97
  .byte 99
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_609:
  .quad .Laot_word_entry_608
  .quad .Laot_word_name_609
  .quad aot_set_fw_61632d6e616d65
.section .text
aot_get_fw_6170742d746f6b656e:
  leaq reg_fw_6170742d746f6b656e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6170742d746f6b656e:
  leaq reg_fw_6170742d746f6b656e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_610:
  .byte 97
  .byte 112
  .byte 116
  .byte 45
  .byte 116
  .byte 111
  .byte 107
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_610:
  .quad .Laot_word_entry_609
  .quad .Laot_word_name_610
  .quad aot_get_fw_6170742d746f6b656e
.section .rodata
.Laot_word_name_611:
  .byte 58
  .byte 97
  .byte 112
  .byte 116
  .byte 45
  .byte 116
  .byte 111
  .byte 107
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_611:
  .quad .Laot_word_entry_610
  .quad .Laot_word_name_611
  .quad aot_set_fw_6170742d746f6b656e
.section .text
aot_get_fw_6170742d76616c6964:
  leaq reg_fw_6170742d76616c6964(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6170742d76616c6964:
  leaq reg_fw_6170742d76616c6964(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_612:
  .byte 97
  .byte 112
  .byte 116
  .byte 45
  .byte 118
  .byte 97
  .byte 108
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_612:
  .quad .Laot_word_entry_611
  .quad .Laot_word_name_612
  .quad aot_get_fw_6170742d76616c6964
.section .rodata
.Laot_word_name_613:
  .byte 58
  .byte 97
  .byte 112
  .byte 116
  .byte 45
  .byte 118
  .byte 97
  .byte 108
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_613:
  .quad .Laot_word_entry_612
  .quad .Laot_word_name_613
  .quad aot_set_fw_6170742d76616c6964
.section .text
aot_get_fw_6170742d64656e:
  leaq reg_fw_6170742d64656e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6170742d64656e:
  leaq reg_fw_6170742d64656e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_614:
  .byte 97
  .byte 112
  .byte 116
  .byte 45
  .byte 100
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_614:
  .quad .Laot_word_entry_613
  .quad .Laot_word_name_614
  .quad aot_get_fw_6170742d64656e
.section .rodata
.Laot_word_name_615:
  .byte 58
  .byte 97
  .byte 112
  .byte 116
  .byte 45
  .byte 100
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_615:
  .quad .Laot_word_entry_614
  .quad .Laot_word_name_615
  .quad aot_set_fw_6170742d64656e
.section .text
aot_get_fw_6170742d6e756d:
  leaq reg_fw_6170742d6e756d(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6170742d6e756d:
  leaq reg_fw_6170742d6e756d(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_616:
  .byte 97
  .byte 112
  .byte 116
  .byte 45
  .byte 110
  .byte 117
  .byte 109
  .byte 0
.section .data
.Laot_word_entry_616:
  .quad .Laot_word_entry_615
  .quad .Laot_word_name_616
  .quad aot_get_fw_6170742d6e756d
.section .rodata
.Laot_word_name_617:
  .byte 58
  .byte 97
  .byte 112
  .byte 116
  .byte 45
  .byte 110
  .byte 117
  .byte 109
  .byte 0
.section .data
.Laot_word_entry_617:
  .quad .Laot_word_entry_616
  .quad .Laot_word_name_617
  .quad aot_set_fw_6170742d6e756d
.section .text
aot_get_fw_61702d696e707574:
  leaq reg_fw_61702d696e707574(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61702d696e707574:
  leaq reg_fw_61702d696e707574(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_618:
  .byte 97
  .byte 112
  .byte 45
  .byte 105
  .byte 110
  .byte 112
  .byte 117
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_618:
  .quad .Laot_word_entry_617
  .quad .Laot_word_name_618
  .quad aot_get_fw_61702d696e707574
.section .rodata
.Laot_word_name_619:
  .byte 58
  .byte 97
  .byte 112
  .byte 45
  .byte 105
  .byte 110
  .byte 112
  .byte 117
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_619:
  .quad .Laot_word_entry_618
  .quad .Laot_word_name_619
  .quad aot_set_fw_61702d696e707574
.section .text
aot_get_fw_61702d696e2d646566:
  leaq reg_fw_61702d696e2d646566(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61702d696e2d646566:
  leaq reg_fw_61702d696e2d646566(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_620:
  .byte 97
  .byte 112
  .byte 45
  .byte 105
  .byte 110
  .byte 45
  .byte 100
  .byte 101
  .byte 102
  .byte 0
.section .data
.Laot_word_entry_620:
  .quad .Laot_word_entry_619
  .quad .Laot_word_name_620
  .quad aot_get_fw_61702d696e2d646566
.section .rodata
.Laot_word_name_621:
  .byte 58
  .byte 97
  .byte 112
  .byte 45
  .byte 105
  .byte 110
  .byte 45
  .byte 100
  .byte 101
  .byte 102
  .byte 0
.section .data
.Laot_word_entry_621:
  .quad .Laot_word_entry_620
  .quad .Laot_word_name_621
  .quad aot_set_fw_61702d696e2d646566
.section .text
aot_get_fw_61632d6e6578742d6964:
  leaq reg_fw_61632d6e6578742d6964(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61632d6e6578742d6964:
  leaq reg_fw_61632d6e6578742d6964(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_622:
  .byte 97
  .byte 99
  .byte 45
  .byte 110
  .byte 101
  .byte 120
  .byte 116
  .byte 45
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_622:
  .quad .Laot_word_entry_621
  .quad .Laot_word_name_622
  .quad aot_get_fw_61632d6e6578742d6964
.section .rodata
.Laot_word_name_623:
  .byte 58
  .byte 97
  .byte 99
  .byte 45
  .byte 110
  .byte 101
  .byte 120
  .byte 116
  .byte 45
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_623:
  .quad .Laot_word_entry_622
  .quad .Laot_word_name_623
  .quad aot_set_fw_61632d6e6578742d6964
.section .text
aot_get_fw_61702d746f6b656e:
  leaq reg_fw_61702d746f6b656e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61702d746f6b656e:
  leaq reg_fw_61702d746f6b656e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_624:
  .byte 97
  .byte 112
  .byte 45
  .byte 116
  .byte 111
  .byte 107
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_624:
  .quad .Laot_word_entry_623
  .quad .Laot_word_name_624
  .quad aot_get_fw_61702d746f6b656e
.section .rodata
.Laot_word_name_625:
  .byte 58
  .byte 97
  .byte 112
  .byte 45
  .byte 116
  .byte 111
  .byte 107
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_625:
  .quad .Laot_word_entry_624
  .quad .Laot_word_name_625
  .quad aot_set_fw_61702d746f6b656e
.section .text
aot_get_fw_61702d6e616d65:
  leaq reg_fw_61702d6e616d65(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61702d6e616d65:
  leaq reg_fw_61702d6e616d65(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_626:
  .byte 97
  .byte 112
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_626:
  .quad .Laot_word_entry_625
  .quad .Laot_word_name_626
  .quad aot_get_fw_61702d6e616d65
.section .rodata
.Laot_word_name_627:
  .byte 58
  .byte 97
  .byte 112
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_627:
  .quad .Laot_word_entry_626
  .quad .Laot_word_name_627
  .quad aot_set_fw_61702d6e616d65
.section .text
aot_get_fw_61632d6964:
  leaq reg_fw_61632d6964(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61632d6964:
  leaq reg_fw_61632d6964(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_628:
  .byte 97
  .byte 99
  .byte 45
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_628:
  .quad .Laot_word_entry_627
  .quad .Laot_word_name_628
  .quad aot_get_fw_61632d6964
.section .rodata
.Laot_word_name_629:
  .byte 58
  .byte 97
  .byte 99
  .byte 45
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_629:
  .quad .Laot_word_entry_628
  .quad .Laot_word_name_629
  .quad aot_set_fw_61632d6964
.section .text
aot_get_fw_61632d746172676574:
  leaq reg_fw_61632d746172676574(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61632d746172676574:
  leaq reg_fw_61632d746172676574(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_630:
  .byte 97
  .byte 99
  .byte 45
  .byte 116
  .byte 97
  .byte 114
  .byte 103
  .byte 101
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_630:
  .quad .Laot_word_entry_629
  .quad .Laot_word_name_630
  .quad aot_get_fw_61632d746172676574
.section .rodata
.Laot_word_name_631:
  .byte 58
  .byte 97
  .byte 99
  .byte 45
  .byte 116
  .byte 97
  .byte 114
  .byte 103
  .byte 101
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_631:
  .quad .Laot_word_entry_630
  .quad .Laot_word_name_631
  .quad aot_set_fw_61632d746172676574
.section .text
aot_get_fw_61632d6f70:
  leaq reg_fw_61632d6f70(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61632d6f70:
  leaq reg_fw_61632d6f70(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_632:
  .byte 97
  .byte 99
  .byte 45
  .byte 111
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_632:
  .quad .Laot_word_entry_631
  .quad .Laot_word_name_632
  .quad aot_get_fw_61632d6f70
.section .rodata
.Laot_word_name_633:
  .byte 58
  .byte 97
  .byte 99
  .byte 45
  .byte 111
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_633:
  .quad .Laot_word_entry_632
  .quad .Laot_word_name_633
  .quad aot_set_fw_61632d6f70
.section .text
aot_get_fw_61692d6f70:
  leaq reg_fw_61692d6f70(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61692d6f70:
  leaq reg_fw_61692d6f70(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_634:
  .byte 97
  .byte 105
  .byte 45
  .byte 111
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_634:
  .quad .Laot_word_entry_633
  .quad .Laot_word_name_634
  .quad aot_get_fw_61692d6f70
.section .rodata
.Laot_word_name_635:
  .byte 58
  .byte 97
  .byte 105
  .byte 45
  .byte 111
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_635:
  .quad .Laot_word_entry_634
  .quad .Laot_word_name_635
  .quad aot_set_fw_61692d6f70
.section .text
aot_get_fw_61692d6964:
  leaq reg_fw_61692d6964(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61692d6964:
  leaq reg_fw_61692d6964(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_636:
  .byte 97
  .byte 105
  .byte 45
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_636:
  .quad .Laot_word_entry_635
  .quad .Laot_word_name_636
  .quad aot_get_fw_61692d6964
.section .rodata
.Laot_word_name_637:
  .byte 58
  .byte 97
  .byte 105
  .byte 45
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_637:
  .quad .Laot_word_entry_636
  .quad .Laot_word_name_637
  .quad aot_set_fw_61692d6964
.section .text
aot_get_fw_61622d6964:
  leaq reg_fw_61622d6964(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61622d6964:
  leaq reg_fw_61622d6964(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_638:
  .byte 97
  .byte 98
  .byte 45
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_638:
  .quad .Laot_word_entry_637
  .quad .Laot_word_name_638
  .quad aot_get_fw_61622d6964
.section .rodata
.Laot_word_name_639:
  .byte 58
  .byte 97
  .byte 98
  .byte 45
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_639:
  .quad .Laot_word_entry_638
  .quad .Laot_word_name_639
  .quad aot_set_fw_61622d6964
.section .text
aot_get_fw_61652d6f6c64:
  leaq reg_fw_61652d6f6c64(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61652d6f6c64:
  leaq reg_fw_61652d6f6c64(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_640:
  .byte 97
  .byte 101
  .byte 45
  .byte 111
  .byte 108
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_640:
  .quad .Laot_word_entry_639
  .quad .Laot_word_name_640
  .quad aot_get_fw_61652d6f6c64
.section .rodata
.Laot_word_name_641:
  .byte 58
  .byte 97
  .byte 101
  .byte 45
  .byte 111
  .byte 108
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_641:
  .quad .Laot_word_entry_640
  .quad .Laot_word_name_641
  .quad aot_set_fw_61652d6f6c64
.section .text
aot_get_fw_61652d746167:
  leaq reg_fw_61652d746167(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61652d746167:
  leaq reg_fw_61652d746167(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_642:
  .byte 97
  .byte 101
  .byte 45
  .byte 116
  .byte 97
  .byte 103
  .byte 0
.section .data
.Laot_word_entry_642:
  .quad .Laot_word_entry_641
  .quad .Laot_word_name_642
  .quad aot_get_fw_61652d746167
.section .rodata
.Laot_word_name_643:
  .byte 58
  .byte 97
  .byte 101
  .byte 45
  .byte 116
  .byte 97
  .byte 103
  .byte 0
.section .data
.Laot_word_entry_643:
  .quad .Laot_word_entry_642
  .quad .Laot_word_name_643
  .quad aot_set_fw_61652d746167
.section .text
aot_get_fw_61652d656e64:
  leaq reg_fw_61652d656e64(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61652d656e64:
  leaq reg_fw_61652d656e64(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_644:
  .byte 97
  .byte 101
  .byte 45
  .byte 101
  .byte 110
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_644:
  .quad .Laot_word_entry_643
  .quad .Laot_word_name_644
  .quad aot_get_fw_61652d656e64
.section .rodata
.Laot_word_name_645:
  .byte 58
  .byte 97
  .byte 101
  .byte 45
  .byte 101
  .byte 110
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_645:
  .quad .Laot_word_entry_644
  .quad .Laot_word_name_645
  .quad aot_set_fw_61652d656e64
.section .text
aot_get_fw_61742d6964:
  leaq reg_fw_61742d6964(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61742d6964:
  leaq reg_fw_61742d6964(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_646:
  .byte 97
  .byte 116
  .byte 45
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_646:
  .quad .Laot_word_entry_645
  .quad .Laot_word_name_646
  .quad aot_get_fw_61742d6964
.section .rodata
.Laot_word_name_647:
  .byte 58
  .byte 97
  .byte 116
  .byte 45
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_647:
  .quad .Laot_word_entry_646
  .quad .Laot_word_name_647
  .quad aot_set_fw_61742d6964
.section .text
aot_get_fw_61742d746167:
  leaq reg_fw_61742d746167(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61742d746167:
  leaq reg_fw_61742d746167(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_648:
  .byte 97
  .byte 116
  .byte 45
  .byte 116
  .byte 97
  .byte 103
  .byte 0
.section .data
.Laot_word_entry_648:
  .quad .Laot_word_entry_647
  .quad .Laot_word_name_648
  .quad aot_get_fw_61742d746167
.section .rodata
.Laot_word_name_649:
  .byte 58
  .byte 97
  .byte 116
  .byte 45
  .byte 116
  .byte 97
  .byte 103
  .byte 0
.section .data
.Laot_word_entry_649:
  .quad .Laot_word_entry_648
  .quad .Laot_word_name_649
  .quad aot_set_fw_61742d746167
.section .text
aot_get_fw_61772d626567696e:
  leaq reg_fw_61772d626567696e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61772d626567696e:
  leaq reg_fw_61772d626567696e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_650:
  .byte 97
  .byte 119
  .byte 45
  .byte 98
  .byte 101
  .byte 103
  .byte 105
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_650:
  .quad .Laot_word_entry_649
  .quad .Laot_word_name_650
  .quad aot_get_fw_61772d626567696e
.section .rodata
.Laot_word_name_651:
  .byte 58
  .byte 97
  .byte 119
  .byte 45
  .byte 98
  .byte 101
  .byte 103
  .byte 105
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_651:
  .quad .Laot_word_entry_650
  .quad .Laot_word_name_651
  .quad aot_set_fw_61772d626567696e
.section .text
aot_get_fw_61772d746167:
  leaq reg_fw_61772d746167(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61772d746167:
  leaq reg_fw_61772d746167(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_652:
  .byte 97
  .byte 119
  .byte 45
  .byte 116
  .byte 97
  .byte 103
  .byte 0
.section .data
.Laot_word_entry_652:
  .quad .Laot_word_entry_651
  .quad .Laot_word_name_652
  .quad aot_get_fw_61772d746167
.section .rodata
.Laot_word_name_653:
  .byte 58
  .byte 97
  .byte 119
  .byte 45
  .byte 116
  .byte 97
  .byte 103
  .byte 0
.section .data
.Laot_word_entry_653:
  .quad .Laot_word_entry_652
  .quad .Laot_word_name_653
  .quad aot_set_fw_61772d746167
.section .text
aot_get_fw_61772d656e64:
  leaq reg_fw_61772d656e64(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61772d656e64:
  leaq reg_fw_61772d656e64(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_654:
  .byte 97
  .byte 119
  .byte 45
  .byte 101
  .byte 110
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_654:
  .quad .Laot_word_entry_653
  .quad .Laot_word_name_654
  .quad aot_get_fw_61772d656e64
.section .rodata
.Laot_word_name_655:
  .byte 58
  .byte 97
  .byte 119
  .byte 45
  .byte 101
  .byte 110
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_655:
  .quad .Laot_word_entry_654
  .quad .Laot_word_name_655
  .quad aot_set_fw_61772d656e64
.section .text
aot_get_fw_61612d7374617274:
  leaq reg_fw_61612d7374617274(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61612d7374617274:
  leaq reg_fw_61612d7374617274(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_656:
  .byte 97
  .byte 97
  .byte 45
  .byte 115
  .byte 116
  .byte 97
  .byte 114
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_656:
  .quad .Laot_word_entry_655
  .quad .Laot_word_name_656
  .quad aot_get_fw_61612d7374617274
.section .rodata
.Laot_word_name_657:
  .byte 58
  .byte 97
  .byte 97
  .byte 45
  .byte 115
  .byte 116
  .byte 97
  .byte 114
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_657:
  .quad .Laot_word_entry_656
  .quad .Laot_word_name_657
  .quad aot_set_fw_61612d7374617274
.section .text
aot_get_fw_61612d746167:
  leaq reg_fw_61612d746167(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61612d746167:
  leaq reg_fw_61612d746167(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_658:
  .byte 97
  .byte 97
  .byte 45
  .byte 116
  .byte 97
  .byte 103
  .byte 0
.section .data
.Laot_word_entry_658:
  .quad .Laot_word_entry_657
  .quad .Laot_word_name_658
  .quad aot_get_fw_61612d746167
.section .rodata
.Laot_word_name_659:
  .byte 58
  .byte 97
  .byte 97
  .byte 45
  .byte 116
  .byte 97
  .byte 103
  .byte 0
.section .data
.Laot_word_entry_659:
  .quad .Laot_word_entry_658
  .quad .Laot_word_name_659
  .quad aot_set_fw_61612d746167
.section .text
aot_get_fw_61722d656e64:
  leaq reg_fw_61722d656e64(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61722d656e64:
  leaq reg_fw_61722d656e64(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_660:
  .byte 97
  .byte 114
  .byte 45
  .byte 101
  .byte 110
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_660:
  .quad .Laot_word_entry_659
  .quad .Laot_word_name_660
  .quad aot_get_fw_61722d656e64
.section .rodata
.Laot_word_name_661:
  .byte 58
  .byte 97
  .byte 114
  .byte 45
  .byte 101
  .byte 110
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_661:
  .quad .Laot_word_entry_660
  .quad .Laot_word_name_661
  .quad aot_set_fw_61722d656e64
.section .text
aot_get_fw_61722d746167:
  leaq reg_fw_61722d746167(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61722d746167:
  leaq reg_fw_61722d746167(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_662:
  .byte 97
  .byte 114
  .byte 45
  .byte 116
  .byte 97
  .byte 103
  .byte 0
.section .data
.Laot_word_entry_662:
  .quad .Laot_word_entry_661
  .quad .Laot_word_name_662
  .quad aot_get_fw_61722d746167
.section .rodata
.Laot_word_name_663:
  .byte 58
  .byte 97
  .byte 114
  .byte 45
  .byte 116
  .byte 97
  .byte 103
  .byte 0
.section .data
.Laot_word_entry_663:
  .quad .Laot_word_entry_662
  .quad .Laot_word_name_663
  .quad aot_set_fw_61722d746167
.section .text
aot_get_fw_61722d7374617274:
  leaq reg_fw_61722d7374617274(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61722d7374617274:
  leaq reg_fw_61722d7374617274(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_664:
  .byte 97
  .byte 114
  .byte 45
  .byte 115
  .byte 116
  .byte 97
  .byte 114
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_664:
  .quad .Laot_word_entry_663
  .quad .Laot_word_name_664
  .quad aot_get_fw_61722d7374617274
.section .rodata
.Laot_word_name_665:
  .byte 58
  .byte 97
  .byte 114
  .byte 45
  .byte 115
  .byte 116
  .byte 97
  .byte 114
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_665:
  .quad .Laot_word_entry_664
  .quad .Laot_word_name_665
  .quad aot_set_fw_61722d7374617274
.section .text
aot_get_fw_61722d62746167:
  leaq reg_fw_61722d62746167(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61722d62746167:
  leaq reg_fw_61722d62746167(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_666:
  .byte 97
  .byte 114
  .byte 45
  .byte 98
  .byte 116
  .byte 97
  .byte 103
  .byte 0
.section .data
.Laot_word_entry_666:
  .quad .Laot_word_entry_665
  .quad .Laot_word_name_666
  .quad aot_get_fw_61722d62746167
.section .rodata
.Laot_word_name_667:
  .byte 58
  .byte 97
  .byte 114
  .byte 45
  .byte 98
  .byte 116
  .byte 97
  .byte 103
  .byte 0
.section .data
.Laot_word_entry_667:
  .quad .Laot_word_entry_666
  .quad .Laot_word_name_667
  .quad aot_set_fw_61722d62746167
.section .text
aot_get_fw_6163742d74:
  leaq reg_fw_6163742d74(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6163742d74:
  leaq reg_fw_6163742d74(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_668:
  .byte 97
  .byte 99
  .byte 116
  .byte 45
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_668:
  .quad .Laot_word_entry_667
  .quad .Laot_word_name_668
  .quad aot_get_fw_6163742d74
.section .rodata
.Laot_word_name_669:
  .byte 58
  .byte 97
  .byte 99
  .byte 116
  .byte 45
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_669:
  .quad .Laot_word_entry_668
  .quad .Laot_word_name_669
  .quad aot_set_fw_6163742d74
.section .text
aot_get_fw_6170772d746f6b656e:
  leaq reg_fw_6170772d746f6b656e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6170772d746f6b656e:
  leaq reg_fw_6170772d746f6b656e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_670:
  .byte 97
  .byte 112
  .byte 119
  .byte 45
  .byte 116
  .byte 111
  .byte 107
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_670:
  .quad .Laot_word_entry_669
  .quad .Laot_word_name_670
  .quad aot_get_fw_6170772d746f6b656e
.section .rodata
.Laot_word_name_671:
  .byte 58
  .byte 97
  .byte 112
  .byte 119
  .byte 45
  .byte 116
  .byte 111
  .byte 107
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_671:
  .quad .Laot_word_entry_670
  .quad .Laot_word_name_671
  .quad aot_set_fw_6170772d746f6b656e
.section .text
aot_get_fw_6170772d737461747573:
  leaq reg_fw_6170772d737461747573(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6170772d737461747573:
  leaq reg_fw_6170772d737461747573(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_672:
  .byte 97
  .byte 112
  .byte 119
  .byte 45
  .byte 115
  .byte 116
  .byte 97
  .byte 116
  .byte 117
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_672:
  .quad .Laot_word_entry_671
  .quad .Laot_word_name_672
  .quad aot_get_fw_6170772d737461747573
.section .rodata
.Laot_word_name_673:
  .byte 58
  .byte 97
  .byte 112
  .byte 119
  .byte 45
  .byte 115
  .byte 116
  .byte 97
  .byte 116
  .byte 117
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_673:
  .quad .Laot_word_entry_672
  .quad .Laot_word_name_673
  .quad aot_set_fw_6170772d737461747573
.section .text
aot_get_fw_6164622d6e:
  leaq reg_fw_6164622d6e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6164622d6e:
  leaq reg_fw_6164622d6e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_674:
  .byte 97
  .byte 100
  .byte 98
  .byte 45
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_674:
  .quad .Laot_word_entry_673
  .quad .Laot_word_name_674
  .quad aot_get_fw_6164622d6e
.section .rodata
.Laot_word_name_675:
  .byte 58
  .byte 97
  .byte 100
  .byte 98
  .byte 45
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_675:
  .quad .Laot_word_entry_674
  .quad .Laot_word_name_675
  .quad aot_set_fw_6164622d6e
.section .text
aot_get_fw_61736c2d6964:
  leaq reg_fw_61736c2d6964(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61736c2d6964:
  leaq reg_fw_61736c2d6964(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_676:
  .byte 97
  .byte 115
  .byte 108
  .byte 45
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_676:
  .quad .Laot_word_entry_675
  .quad .Laot_word_name_676
  .quad aot_get_fw_61736c2d6964
.section .rodata
.Laot_word_name_677:
  .byte 58
  .byte 97
  .byte 115
  .byte 108
  .byte 45
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_677:
  .quad .Laot_word_entry_676
  .quad .Laot_word_name_677
  .quad aot_set_fw_61736c2d6964
.section .text
aot_get_fw_617374722d74657874:
  leaq reg_fw_617374722d74657874(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_617374722d74657874:
  leaq reg_fw_617374722d74657874(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_678:
  .byte 97
  .byte 115
  .byte 116
  .byte 114
  .byte 45
  .byte 116
  .byte 101
  .byte 120
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_678:
  .quad .Laot_word_entry_677
  .quad .Laot_word_name_678
  .quad aot_get_fw_617374722d74657874
.section .rodata
.Laot_word_name_679:
  .byte 58
  .byte 97
  .byte 115
  .byte 116
  .byte 114
  .byte 45
  .byte 116
  .byte 101
  .byte 120
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_679:
  .quad .Laot_word_entry_678
  .quad .Laot_word_name_679
  .quad aot_set_fw_617374722d74657874
.section .text
aot_get_fw_617374722d6964:
  leaq reg_fw_617374722d6964(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_617374722d6964:
  leaq reg_fw_617374722d6964(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_680:
  .byte 97
  .byte 115
  .byte 116
  .byte 114
  .byte 45
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_680:
  .quad .Laot_word_entry_679
  .quad .Laot_word_name_680
  .quad aot_get_fw_617374722d6964
.section .rodata
.Laot_word_name_681:
  .byte 58
  .byte 97
  .byte 115
  .byte 116
  .byte 114
  .byte 45
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_681:
  .quad .Laot_word_entry_680
  .quad .Laot_word_name_681
  .quad aot_set_fw_617374722d6964
.section .text
aot_get_fw_617374722d706f73:
  leaq reg_fw_617374722d706f73(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_617374722d706f73:
  leaq reg_fw_617374722d706f73(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_682:
  .byte 97
  .byte 115
  .byte 116
  .byte 114
  .byte 45
  .byte 112
  .byte 111
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_682:
  .quad .Laot_word_entry_681
  .quad .Laot_word_name_682
  .quad aot_get_fw_617374722d706f73
.section .rodata
.Laot_word_name_683:
  .byte 58
  .byte 97
  .byte 115
  .byte 116
  .byte 114
  .byte 45
  .byte 112
  .byte 111
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_683:
  .quad .Laot_word_entry_682
  .quad .Laot_word_name_683
  .quad aot_set_fw_617374722d706f73
.section .text
aot_get_fw_617374722d62797465:
  leaq reg_fw_617374722d62797465(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_617374722d62797465:
  leaq reg_fw_617374722d62797465(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_684:
  .byte 97
  .byte 115
  .byte 116
  .byte 114
  .byte 45
  .byte 98
  .byte 121
  .byte 116
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_684:
  .quad .Laot_word_entry_683
  .quad .Laot_word_name_684
  .quad aot_get_fw_617374722d62797465
.section .rodata
.Laot_word_name_685:
  .byte 58
  .byte 97
  .byte 115
  .byte 116
  .byte 114
  .byte 45
  .byte 98
  .byte 121
  .byte 116
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_685:
  .quad .Laot_word_entry_684
  .quad .Laot_word_name_685
  .quad aot_set_fw_617374722d62797465
.section .text
aot_get_fw_6172652d706f73:
  leaq reg_fw_6172652d706f73(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6172652d706f73:
  leaq reg_fw_6172652d706f73(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_686:
  .byte 97
  .byte 114
  .byte 101
  .byte 45
  .byte 112
  .byte 111
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_686:
  .quad .Laot_word_entry_685
  .quad .Laot_word_name_686
  .quad aot_get_fw_6172652d706f73
.section .rodata
.Laot_word_name_687:
  .byte 58
  .byte 97
  .byte 114
  .byte 101
  .byte 45
  .byte 112
  .byte 111
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_687:
  .quad .Laot_word_entry_686
  .quad .Laot_word_name_687
  .quad aot_set_fw_6172652d706f73
.section .text
aot_get_fw_6172662d6e616d65:
  leaq reg_fw_6172662d6e616d65(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6172662d6e616d65:
  leaq reg_fw_6172662d6e616d65(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_688:
  .byte 97
  .byte 114
  .byte 102
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_688:
  .quad .Laot_word_entry_687
  .quad .Laot_word_name_688
  .quad aot_get_fw_6172662d6e616d65
.section .rodata
.Laot_word_name_689:
  .byte 58
  .byte 97
  .byte 114
  .byte 102
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_689:
  .quad .Laot_word_entry_688
  .quad .Laot_word_name_689
  .quad aot_set_fw_6172662d6e616d65
.section .text
aot_get_fw_6172662d706f73:
  leaq reg_fw_6172662d706f73(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6172662d706f73:
  leaq reg_fw_6172662d706f73(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_690:
  .byte 97
  .byte 114
  .byte 102
  .byte 45
  .byte 112
  .byte 111
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_690:
  .quad .Laot_word_entry_689
  .quad .Laot_word_name_690
  .quad aot_get_fw_6172662d706f73
.section .rodata
.Laot_word_name_691:
  .byte 58
  .byte 97
  .byte 114
  .byte 102
  .byte 45
  .byte 112
  .byte 111
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_691:
  .quad .Laot_word_entry_690
  .quad .Laot_word_name_691
  .quad aot_set_fw_6172662d706f73
.section .text
aot_get_fw_6172722d6e616d65:
  leaq reg_fw_6172722d6e616d65(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6172722d6e616d65:
  leaq reg_fw_6172722d6e616d65(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_692:
  .byte 97
  .byte 114
  .byte 114
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_692:
  .quad .Laot_word_entry_691
  .quad .Laot_word_name_692
  .quad aot_get_fw_6172722d6e616d65
.section .rodata
.Laot_word_name_693:
  .byte 58
  .byte 97
  .byte 114
  .byte 114
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_693:
  .quad .Laot_word_entry_692
  .quad .Laot_word_name_693
  .quad aot_set_fw_6172722d6e616d65
.section .text
aot_get_fw_6172722d706f73:
  leaq reg_fw_6172722d706f73(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6172722d706f73:
  leaq reg_fw_6172722d706f73(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_694:
  .byte 97
  .byte 114
  .byte 114
  .byte 45
  .byte 112
  .byte 111
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_694:
  .quad .Laot_word_entry_693
  .quad .Laot_word_name_694
  .quad aot_get_fw_6172722d706f73
.section .rodata
.Laot_word_name_695:
  .byte 58
  .byte 97
  .byte 114
  .byte 114
  .byte 45
  .byte 112
  .byte 111
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_695:
  .quad .Laot_word_entry_694
  .quad .Laot_word_name_695
  .quad aot_set_fw_6172722d706f73
.section .text
aot_get_fw_6172722d62797465:
  leaq reg_fw_6172722d62797465(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6172722d62797465:
  leaq reg_fw_6172722d62797465(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_696:
  .byte 97
  .byte 114
  .byte 114
  .byte 45
  .byte 98
  .byte 121
  .byte 116
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_696:
  .quad .Laot_word_entry_695
  .quad .Laot_word_name_696
  .quad aot_get_fw_6172722d62797465
.section .rodata
.Laot_word_name_697:
  .byte 58
  .byte 97
  .byte 114
  .byte 114
  .byte 45
  .byte 98
  .byte 121
  .byte 116
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_697:
  .quad .Laot_word_entry_696
  .quad .Laot_word_name_697
  .quad aot_set_fw_6172722d62797465
.section .text
aot_get_fw_616f742d7265672d75736564:
  leaq reg_fw_616f742d7265672d75736564(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_616f742d7265672d75736564:
  leaq reg_fw_616f742d7265672d75736564(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_698:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 114
  .byte 101
  .byte 103
  .byte 45
  .byte 117
  .byte 115
  .byte 101
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_698:
  .quad .Laot_word_entry_697
  .quad .Laot_word_name_698
  .quad aot_get_fw_616f742d7265672d75736564
.section .rodata
.Laot_word_name_699:
  .byte 58
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 114
  .byte 101
  .byte 103
  .byte 45
  .byte 117
  .byte 115
  .byte 101
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_699:
  .quad .Laot_word_entry_698
  .quad .Laot_word_name_699
  .quad aot_set_fw_616f742d7265672d75736564
.section .text
aot_get_fw_6172732d736f75726365:
  leaq reg_fw_6172732d736f75726365(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6172732d736f75726365:
  leaq reg_fw_6172732d736f75726365(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_700:
  .byte 97
  .byte 114
  .byte 115
  .byte 45
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_700:
  .quad .Laot_word_entry_699
  .quad .Laot_word_name_700
  .quad aot_get_fw_6172732d736f75726365
.section .rodata
.Laot_word_name_701:
  .byte 58
  .byte 97
  .byte 114
  .byte 115
  .byte 45
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_701:
  .quad .Laot_word_entry_700
  .quad .Laot_word_name_701
  .quad aot_set_fw_6172732d736f75726365
.section .text
aot_get_fw_6172732d746f6b656e:
  leaq reg_fw_6172732d746f6b656e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6172732d746f6b656e:
  leaq reg_fw_6172732d746f6b656e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_702:
  .byte 97
  .byte 114
  .byte 115
  .byte 45
  .byte 116
  .byte 111
  .byte 107
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_702:
  .quad .Laot_word_entry_701
  .quad .Laot_word_name_702
  .quad aot_get_fw_6172732d746f6b656e
.section .rodata
.Laot_word_name_703:
  .byte 58
  .byte 97
  .byte 114
  .byte 115
  .byte 45
  .byte 116
  .byte 111
  .byte 107
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_703:
  .quad .Laot_word_entry_702
  .quad .Laot_word_name_703
  .quad aot_set_fw_6172732d746f6b656e
.section .text
aot_get_fw_61726c2d6e616d65:
  leaq reg_fw_61726c2d6e616d65(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61726c2d6e616d65:
  leaq reg_fw_61726c2d6e616d65(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_704:
  .byte 97
  .byte 114
  .byte 108
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_704:
  .quad .Laot_word_entry_703
  .quad .Laot_word_name_704
  .quad aot_get_fw_61726c2d6e616d65
.section .rodata
.Laot_word_name_705:
  .byte 58
  .byte 97
  .byte 114
  .byte 108
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_705:
  .quad .Laot_word_entry_704
  .quad .Laot_word_name_705
  .quad aot_set_fw_61726c2d6e616d65
.section .text
aot_get_fw_6172612d6e616d65:
  leaq reg_fw_6172612d6e616d65(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6172612d6e616d65:
  leaq reg_fw_6172612d6e616d65(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_706:
  .byte 97
  .byte 114
  .byte 97
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_706:
  .quad .Laot_word_entry_705
  .quad .Laot_word_name_706
  .quad aot_get_fw_6172612d6e616d65
.section .rodata
.Laot_word_name_707:
  .byte 58
  .byte 97
  .byte 114
  .byte 97
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_707:
  .quad .Laot_word_entry_706
  .quad .Laot_word_name_707
  .quad aot_set_fw_6172612d6e616d65
.section .text
aot_get_fw_6172732d6e616d65:
  leaq reg_fw_6172732d6e616d65(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6172732d6e616d65:
  leaq reg_fw_6172732d6e616d65(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_708:
  .byte 97
  .byte 114
  .byte 115
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_708:
  .quad .Laot_word_entry_707
  .quad .Laot_word_name_708
  .quad aot_get_fw_6172732d6e616d65
.section .rodata
.Laot_word_name_709:
  .byte 58
  .byte 97
  .byte 114
  .byte 115
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_709:
  .quad .Laot_word_entry_708
  .quad .Laot_word_name_709
  .quad aot_set_fw_6172732d6e616d65
.section .text
aot_get_fw_6172672d6e616d65:
  leaq reg_fw_6172672d6e616d65(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6172672d6e616d65:
  leaq reg_fw_6172672d6e616d65(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_710:
  .byte 97
  .byte 114
  .byte 103
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_710:
  .quad .Laot_word_entry_709
  .quad .Laot_word_name_710
  .quad aot_get_fw_6172672d6e616d65
.section .rodata
.Laot_word_name_711:
  .byte 58
  .byte 97
  .byte 114
  .byte 103
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_711:
  .quad .Laot_word_entry_710
  .quad .Laot_word_name_711
  .quad aot_set_fw_6172672d6e616d65
.section .text
aot_get_fw_6173632d63686172:
  leaq reg_fw_6173632d63686172(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6173632d63686172:
  leaq reg_fw_6173632d63686172(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_712:
  .byte 97
  .byte 115
  .byte 99
  .byte 45
  .byte 99
  .byte 104
  .byte 97
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_712:
  .quad .Laot_word_entry_711
  .quad .Laot_word_name_712
  .quad aot_get_fw_6173632d63686172
.section .rodata
.Laot_word_name_713:
  .byte 58
  .byte 97
  .byte 115
  .byte 99
  .byte 45
  .byte 99
  .byte 104
  .byte 97
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_713:
  .quad .Laot_word_entry_712
  .quad .Laot_word_name_713
  .quad aot_set_fw_6173632d63686172
.section .text
aot_get_fw_61782d6368:
  leaq reg_fw_61782d6368(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61782d6368:
  leaq reg_fw_61782d6368(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_714:
  .byte 97
  .byte 120
  .byte 45
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_714:
  .quad .Laot_word_entry_713
  .quad .Laot_word_name_714
  .quad aot_get_fw_61782d6368
.section .rodata
.Laot_word_name_715:
  .byte 58
  .byte 97
  .byte 120
  .byte 45
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_715:
  .quad .Laot_word_entry_714
  .quad .Laot_word_name_715
  .quad aot_set_fw_61782d6368
.section .text
aot_get_fw_61782d647374:
  leaq reg_fw_61782d647374(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61782d647374:
  leaq reg_fw_61782d647374(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_716:
  .byte 97
  .byte 120
  .byte 45
  .byte 100
  .byte 115
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_716:
  .quad .Laot_word_entry_715
  .quad .Laot_word_name_716
  .quad aot_get_fw_61782d647374
.section .rodata
.Laot_word_name_717:
  .byte 58
  .byte 97
  .byte 120
  .byte 45
  .byte 100
  .byte 115
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_717:
  .quad .Laot_word_entry_716
  .quad .Laot_word_name_717
  .quad aot_set_fw_61782d647374
.section .text
aot_get_fw_61782d71756f7465:
  leaq reg_fw_61782d71756f7465(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61782d71756f7465:
  leaq reg_fw_61782d71756f7465(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_718:
  .byte 97
  .byte 120
  .byte 45
  .byte 113
  .byte 117
  .byte 111
  .byte 116
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_718:
  .quad .Laot_word_entry_717
  .quad .Laot_word_name_718
  .quad aot_get_fw_61782d71756f7465
.section .rodata
.Laot_word_name_719:
  .byte 58
  .byte 97
  .byte 120
  .byte 45
  .byte 113
  .byte 117
  .byte 111
  .byte 116
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_719:
  .quad .Laot_word_entry_718
  .quad .Laot_word_name_719
  .quad aot_set_fw_61782d71756f7465
.section .text
aot_get_fw_61782d657363617065:
  leaq reg_fw_61782d657363617065(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61782d657363617065:
  leaq reg_fw_61782d657363617065(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_720:
  .byte 97
  .byte 120
  .byte 45
  .byte 101
  .byte 115
  .byte 99
  .byte 97
  .byte 112
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_720:
  .quad .Laot_word_entry_719
  .quad .Laot_word_name_720
  .quad aot_get_fw_61782d657363617065
.section .rodata
.Laot_word_name_721:
  .byte 58
  .byte 97
  .byte 120
  .byte 45
  .byte 101
  .byte 115
  .byte 99
  .byte 97
  .byte 112
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_721:
  .quad .Laot_word_entry_720
  .quad .Laot_word_name_721
  .quad aot_set_fw_61782d657363617065
.section .text
aot_get_fw_61782d636f756e74:
  leaq reg_fw_61782d636f756e74(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61782d636f756e74:
  leaq reg_fw_61782d636f756e74(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_722:
  .byte 97
  .byte 120
  .byte 45
  .byte 99
  .byte 111
  .byte 117
  .byte 110
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_722:
  .quad .Laot_word_entry_721
  .quad .Laot_word_name_722
  .quad aot_get_fw_61782d636f756e74
.section .rodata
.Laot_word_name_723:
  .byte 58
  .byte 97
  .byte 120
  .byte 45
  .byte 99
  .byte 111
  .byte 117
  .byte 110
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_723:
  .quad .Laot_word_entry_722
  .quad .Laot_word_name_723
  .quad aot_set_fw_61782d636f756e74
.section .text
aot_get_fw_616b2d736f75726365:
  leaq reg_fw_616b2d736f75726365(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_616b2d736f75726365:
  leaq reg_fw_616b2d736f75726365(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_724:
  .byte 97
  .byte 107
  .byte 45
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_724:
  .quad .Laot_word_entry_723
  .quad .Laot_word_name_724
  .quad aot_get_fw_616b2d736f75726365
.section .rodata
.Laot_word_name_725:
  .byte 58
  .byte 97
  .byte 107
  .byte 45
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_725:
  .quad .Laot_word_entry_724
  .quad .Laot_word_name_725
  .quad aot_set_fw_616b2d736f75726365
.section .text
aot_get_fw_616f742d6b65726e656c2d6d6f6465:
  leaq reg_fw_616f742d6b65726e656c2d6d6f6465(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_616f742d6b65726e656c2d6d6f6465:
  leaq reg_fw_616f742d6b65726e656c2d6d6f6465(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_726:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 107
  .byte 101
  .byte 114
  .byte 110
  .byte 101
  .byte 108
  .byte 45
  .byte 109
  .byte 111
  .byte 100
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_726:
  .quad .Laot_word_entry_725
  .quad .Laot_word_name_726
  .quad aot_get_fw_616f742d6b65726e656c2d6d6f6465
.section .rodata
.Laot_word_name_727:
  .byte 58
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 107
  .byte 101
  .byte 114
  .byte 110
  .byte 101
  .byte 108
  .byte 45
  .byte 109
  .byte 111
  .byte 100
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_727:
  .quad .Laot_word_entry_726
  .quad .Laot_word_name_727
  .quad aot_set_fw_616f742d6b65726e656c2d6d6f6465
.section .text
aot_get_fw_616b2d6f6b:
  leaq reg_fw_616b2d6f6b(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_616b2d6f6b:
  leaq reg_fw_616b2d6f6b(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_728:
  .byte 97
  .byte 107
  .byte 45
  .byte 111
  .byte 107
  .byte 0
.section .data
.Laot_word_entry_728:
  .quad .Laot_word_entry_727
  .quad .Laot_word_name_728
  .quad aot_get_fw_616b2d6f6b
.section .rodata
.Laot_word_name_729:
  .byte 58
  .byte 97
  .byte 107
  .byte 45
  .byte 111
  .byte 107
  .byte 0
.section .data
.Laot_word_entry_729:
  .quad .Laot_word_entry_728
  .quad .Laot_word_name_729
  .quad aot_set_fw_616b2d6f6b
.section .text
aot_get_fw_616e622d6e616d65:
  leaq reg_fw_616e622d6e616d65(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_616e622d6e616d65:
  leaq reg_fw_616e622d6e616d65(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_730:
  .byte 97
  .byte 110
  .byte 98
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_730:
  .quad .Laot_word_entry_729
  .quad .Laot_word_name_730
  .quad aot_get_fw_616e622d6e616d65
.section .rodata
.Laot_word_name_731:
  .byte 58
  .byte 97
  .byte 110
  .byte 98
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_731:
  .quad .Laot_word_entry_730
  .quad .Laot_word_name_731
  .quad aot_set_fw_616e622d6e616d65
.section .text
aot_get_fw_616e622d63686172:
  leaq reg_fw_616e622d63686172(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_616e622d63686172:
  leaq reg_fw_616e622d63686172(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_732:
  .byte 97
  .byte 110
  .byte 98
  .byte 45
  .byte 99
  .byte 104
  .byte 97
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_732:
  .quad .Laot_word_entry_731
  .quad .Laot_word_name_732
  .quad aot_get_fw_616e622d63686172
.section .rodata
.Laot_word_name_733:
  .byte 58
  .byte 97
  .byte 110
  .byte 98
  .byte 45
  .byte 99
  .byte 104
  .byte 97
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_733:
  .quad .Laot_word_entry_732
  .quad .Laot_word_name_733
  .quad aot_set_fw_616e622d63686172
.section .text
aot_get_fw_6166622d6e616d65:
  leaq reg_fw_6166622d6e616d65(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6166622d6e616d65:
  leaq reg_fw_6166622d6e616d65(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_734:
  .byte 97
  .byte 102
  .byte 98
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_734:
  .quad .Laot_word_entry_733
  .quad .Laot_word_name_734
  .quad aot_get_fw_6166622d6e616d65
.section .rodata
.Laot_word_name_735:
  .byte 58
  .byte 97
  .byte 102
  .byte 98
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_735:
  .quad .Laot_word_entry_734
  .quad .Laot_word_name_735
  .quad aot_set_fw_6166622d6e616d65
.section .text
aot_get_fw_6166622d63686172:
  leaq reg_fw_6166622d63686172(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6166622d63686172:
  leaq reg_fw_6166622d63686172(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_736:
  .byte 97
  .byte 102
  .byte 98
  .byte 45
  .byte 99
  .byte 104
  .byte 97
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_736:
  .quad .Laot_word_entry_735
  .quad .Laot_word_name_736
  .quad aot_get_fw_6166622d63686172
.section .rodata
.Laot_word_name_737:
  .byte 58
  .byte 97
  .byte 102
  .byte 98
  .byte 45
  .byte 99
  .byte 104
  .byte 97
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_737:
  .quad .Laot_word_entry_736
  .quad .Laot_word_name_737
  .quad aot_set_fw_6166622d63686172
.section .text
aot_get_fw_6165662d70:
  leaq reg_fw_6165662d70(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6165662d70:
  leaq reg_fw_6165662d70(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_738:
  .byte 97
  .byte 101
  .byte 102
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_738:
  .quad .Laot_word_entry_737
  .quad .Laot_word_name_738
  .quad aot_get_fw_6165662d70
.section .rodata
.Laot_word_name_739:
  .byte 58
  .byte 97
  .byte 101
  .byte 102
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_739:
  .quad .Laot_word_entry_738
  .quad .Laot_word_name_739
  .quad aot_set_fw_6165662d70
.section .text
aot_get_fw_6165662d6368:
  leaq reg_fw_6165662d6368(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6165662d6368:
  leaq reg_fw_6165662d6368(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_740:
  .byte 97
  .byte 101
  .byte 102
  .byte 45
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_740:
  .quad .Laot_word_entry_739
  .quad .Laot_word_name_740
  .quad aot_get_fw_6165662d6368
.section .rodata
.Laot_word_name_741:
  .byte 58
  .byte 97
  .byte 101
  .byte 102
  .byte 45
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_741:
  .quad .Laot_word_entry_740
  .quad .Laot_word_name_741
  .quad aot_set_fw_6165662d6368
.section .text
aot_get_fw_616d722d6b696e64:
  leaq reg_fw_616d722d6b696e64(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_616d722d6b696e64:
  leaq reg_fw_616d722d6b696e64(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_742:
  .byte 97
  .byte 109
  .byte 114
  .byte 45
  .byte 107
  .byte 105
  .byte 110
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_742:
  .quad .Laot_word_entry_741
  .quad .Laot_word_name_742
  .quad aot_get_fw_616d722d6b696e64
.section .rodata
.Laot_word_name_743:
  .byte 58
  .byte 97
  .byte 109
  .byte 114
  .byte 45
  .byte 107
  .byte 105
  .byte 110
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_743:
  .quad .Laot_word_entry_742
  .quad .Laot_word_name_743
  .quad aot_set_fw_616d722d6b696e64
.section .text
aot_get_fw_616d722d746172676574:
  leaq reg_fw_616d722d746172676574(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_616d722d746172676574:
  leaq reg_fw_616d722d746172676574(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_744:
  .byte 97
  .byte 109
  .byte 114
  .byte 45
  .byte 116
  .byte 97
  .byte 114
  .byte 103
  .byte 101
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_744:
  .quad .Laot_word_entry_743
  .quad .Laot_word_name_744
  .quad aot_get_fw_616d722d746172676574
.section .rodata
.Laot_word_name_745:
  .byte 58
  .byte 97
  .byte 109
  .byte 114
  .byte 45
  .byte 116
  .byte 97
  .byte 114
  .byte 103
  .byte 101
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_745:
  .quad .Laot_word_entry_744
  .quad .Laot_word_name_745
  .quad aot_set_fw_616d722d746172676574
.section .text
aot_get_fw_616d722d6e616d65:
  leaq reg_fw_616d722d6e616d65(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_616d722d6e616d65:
  leaq reg_fw_616d722d6e616d65(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_746:
  .byte 97
  .byte 109
  .byte 114
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_746:
  .quad .Laot_word_entry_745
  .quad .Laot_word_name_746
  .quad aot_get_fw_616d722d6e616d65
.section .rodata
.Laot_word_name_747:
  .byte 58
  .byte 97
  .byte 109
  .byte 114
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_747:
  .quad .Laot_word_entry_746
  .quad .Laot_word_name_747
  .quad aot_set_fw_616d722d6e616d65
.section .text
aot_get_fw_616f742d6d6574612d636f756e74:
  leaq reg_fw_616f742d6d6574612d636f756e74(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_616f742d6d6574612d636f756e74:
  leaq reg_fw_616f742d6d6574612d636f756e74(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_748:
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 109
  .byte 101
  .byte 116
  .byte 97
  .byte 45
  .byte 99
  .byte 111
  .byte 117
  .byte 110
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_748:
  .quad .Laot_word_entry_747
  .quad .Laot_word_name_748
  .quad aot_get_fw_616f742d6d6574612d636f756e74
.section .rodata
.Laot_word_name_749:
  .byte 58
  .byte 97
  .byte 111
  .byte 116
  .byte 45
  .byte 109
  .byte 101
  .byte 116
  .byte 97
  .byte 45
  .byte 99
  .byte 111
  .byte 117
  .byte 110
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_749:
  .quad .Laot_word_entry_748
  .quad .Laot_word_name_749
  .quad aot_set_fw_616f742d6d6574612d636f756e74
.section .text
aot_get_fw_616d742d70:
  leaq reg_fw_616d742d70(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_616d742d70:
  leaq reg_fw_616d742d70(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_750:
  .byte 97
  .byte 109
  .byte 116
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_750:
  .quad .Laot_word_entry_749
  .quad .Laot_word_name_750
  .quad aot_get_fw_616d742d70
.section .rodata
.Laot_word_name_751:
  .byte 58
  .byte 97
  .byte 109
  .byte 116
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_751:
  .quad .Laot_word_entry_750
  .quad .Laot_word_name_751
  .quad aot_set_fw_616d742d70
.section .text
aot_get_fw_616d742d746172676574:
  leaq reg_fw_616d742d746172676574(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_616d742d746172676574:
  leaq reg_fw_616d742d746172676574(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_752:
  .byte 97
  .byte 109
  .byte 116
  .byte 45
  .byte 116
  .byte 97
  .byte 114
  .byte 103
  .byte 101
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_752:
  .quad .Laot_word_entry_751
  .quad .Laot_word_name_752
  .quad aot_get_fw_616d742d746172676574
.section .rodata
.Laot_word_name_753:
  .byte 58
  .byte 97
  .byte 109
  .byte 116
  .byte 45
  .byte 116
  .byte 97
  .byte 114
  .byte 103
  .byte 101
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_753:
  .quad .Laot_word_entry_752
  .quad .Laot_word_name_753
  .quad aot_set_fw_616d742d746172676574
.section .text
aot_get_fw_616d642d736f75726365:
  leaq reg_fw_616d642d736f75726365(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_616d642d736f75726365:
  leaq reg_fw_616d642d736f75726365(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_754:
  .byte 97
  .byte 109
  .byte 100
  .byte 45
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_754:
  .quad .Laot_word_entry_753
  .quad .Laot_word_name_754
  .quad aot_get_fw_616d642d736f75726365
.section .rodata
.Laot_word_name_755:
  .byte 58
  .byte 97
  .byte 109
  .byte 100
  .byte 45
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_755:
  .quad .Laot_word_entry_754
  .quad .Laot_word_name_755
  .quad aot_set_fw_616d642d736f75726365
.section .text
aot_get_fw_616d642d746f6b656e:
  leaq reg_fw_616d642d746f6b656e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_616d642d746f6b656e:
  leaq reg_fw_616d642d746f6b656e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_756:
  .byte 97
  .byte 109
  .byte 100
  .byte 45
  .byte 116
  .byte 111
  .byte 107
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_756:
  .quad .Laot_word_entry_755
  .quad .Laot_word_name_756
  .quad aot_get_fw_616d642d746f6b656e
.section .rodata
.Laot_word_name_757:
  .byte 58
  .byte 97
  .byte 109
  .byte 100
  .byte 45
  .byte 116
  .byte 111
  .byte 107
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_757:
  .quad .Laot_word_entry_756
  .quad .Laot_word_name_757
  .quad aot_set_fw_616d642d746f6b656e
.section .text
aot_get_fw_616d642d646566:
  leaq reg_fw_616d642d646566(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_616d642d646566:
  leaq reg_fw_616d642d646566(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_758:
  .byte 97
  .byte 109
  .byte 100
  .byte 45
  .byte 100
  .byte 101
  .byte 102
  .byte 0
.section .data
.Laot_word_entry_758:
  .quad .Laot_word_entry_757
  .quad .Laot_word_name_758
  .quad aot_get_fw_616d642d646566
.section .rodata
.Laot_word_name_759:
  .byte 58
  .byte 97
  .byte 109
  .byte 100
  .byte 45
  .byte 100
  .byte 101
  .byte 102
  .byte 0
.section .data
.Laot_word_entry_759:
  .quad .Laot_word_entry_758
  .quad .Laot_word_name_759
  .quad aot_set_fw_616d642d646566
.section .text
aot_get_fw_616d732d726567:
  leaq reg_fw_616d732d726567(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_616d732d726567:
  leaq reg_fw_616d732d726567(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_760:
  .byte 97
  .byte 109
  .byte 115
  .byte 45
  .byte 114
  .byte 101
  .byte 103
  .byte 0
.section .data
.Laot_word_entry_760:
  .quad .Laot_word_entry_759
  .quad .Laot_word_name_760
  .quad aot_get_fw_616d732d726567
.section .rodata
.Laot_word_name_761:
  .byte 58
  .byte 97
  .byte 109
  .byte 115
  .byte 45
  .byte 114
  .byte 101
  .byte 103
  .byte 0
.section .data
.Laot_word_entry_761:
  .quad .Laot_word_entry_760
  .quad .Laot_word_name_761
  .quad aot_set_fw_616d732d726567
.section .text
aot_get_fw_616d672d706f73:
  leaq reg_fw_616d672d706f73(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_616d672d706f73:
  leaq reg_fw_616d672d706f73(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_762:
  .byte 97
  .byte 109
  .byte 103
  .byte 45
  .byte 112
  .byte 111
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_762:
  .quad .Laot_word_entry_761
  .quad .Laot_word_name_762
  .quad aot_get_fw_616d672d706f73
.section .rodata
.Laot_word_name_763:
  .byte 58
  .byte 97
  .byte 109
  .byte 103
  .byte 45
  .byte 112
  .byte 111
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_763:
  .quad .Laot_word_entry_762
  .quad .Laot_word_name_763
  .quad aot_set_fw_616d672d706f73
.section .text
aot_get_fw_616d672d726567:
  leaq reg_fw_616d672d726567(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_616d672d726567:
  leaq reg_fw_616d672d726567(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_764:
  .byte 97
  .byte 109
  .byte 103
  .byte 45
  .byte 114
  .byte 101
  .byte 103
  .byte 0
.section .data
.Laot_word_entry_764:
  .quad .Laot_word_entry_763
  .quad .Laot_word_name_764
  .quad aot_get_fw_616d672d726567
.section .rodata
.Laot_word_name_765:
  .byte 58
  .byte 97
  .byte 109
  .byte 103
  .byte 45
  .byte 114
  .byte 101
  .byte 103
  .byte 0
.section .data
.Laot_word_entry_765:
  .quad .Laot_word_entry_764
  .quad .Laot_word_name_765
  .quad aot_set_fw_616d672d726567
.section .text
aot_get_fw_616b6d2d736f75726365:
  leaq reg_fw_616b6d2d736f75726365(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_616b6d2d736f75726365:
  leaq reg_fw_616b6d2d736f75726365(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_766:
  .byte 97
  .byte 107
  .byte 109
  .byte 45
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_766:
  .quad .Laot_word_entry_765
  .quad .Laot_word_name_766
  .quad aot_get_fw_616b6d2d736f75726365
.section .rodata
.Laot_word_name_767:
  .byte 58
  .byte 97
  .byte 107
  .byte 109
  .byte 45
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_767:
  .quad .Laot_word_entry_766
  .quad .Laot_word_name_767
  .quad aot_set_fw_616b6d2d736f75726365
.section .text
aot_get_fw_62732d636f756e74:
  leaq reg_fw_62732d636f756e74(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_62732d636f756e74:
  leaq reg_fw_62732d636f756e74(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_768:
  .byte 98
  .byte 115
  .byte 45
  .byte 99
  .byte 111
  .byte 117
  .byte 110
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_768:
  .quad .Laot_word_entry_767
  .quad .Laot_word_name_768
  .quad aot_get_fw_62732d636f756e74
.section .rodata
.Laot_word_name_769:
  .byte 58
  .byte 98
  .byte 115
  .byte 45
  .byte 99
  .byte 111
  .byte 117
  .byte 110
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_769:
  .quad .Laot_word_entry_768
  .quad .Laot_word_name_769
  .quad aot_set_fw_62732d636f756e74
.section .text
aot_get_fw_62732d6c6261:
  leaq reg_fw_62732d6c6261(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_62732d6c6261:
  leaq reg_fw_62732d6c6261(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_770:
  .byte 98
  .byte 115
  .byte 45
  .byte 108
  .byte 98
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_770:
  .quad .Laot_word_entry_769
  .quad .Laot_word_name_770
  .quad aot_get_fw_62732d6c6261
.section .rodata
.Laot_word_name_771:
  .byte 58
  .byte 98
  .byte 115
  .byte 45
  .byte 108
  .byte 98
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_771:
  .quad .Laot_word_entry_770
  .quad .Laot_word_name_771
  .quad aot_set_fw_62732d6c6261
.section .text
aot_get_fw_62732d696e646578:
  leaq reg_fw_62732d696e646578(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_62732d696e646578:
  leaq reg_fw_62732d696e646578(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_772:
  .byte 98
  .byte 115
  .byte 45
  .byte 105
  .byte 110
  .byte 100
  .byte 101
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_772:
  .quad .Laot_word_entry_771
  .quad .Laot_word_name_772
  .quad aot_get_fw_62732d696e646578
.section .rodata
.Laot_word_name_773:
  .byte 58
  .byte 98
  .byte 115
  .byte 45
  .byte 105
  .byte 110
  .byte 100
  .byte 101
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_773:
  .quad .Laot_word_entry_772
  .quad .Laot_word_name_773
  .quad aot_set_fw_62732d696e646578
.section .text
aot_get_fw_62732d62797465:
  leaq reg_fw_62732d62797465(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_62732d62797465:
  leaq reg_fw_62732d62797465(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_774:
  .byte 98
  .byte 115
  .byte 45
  .byte 98
  .byte 121
  .byte 116
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_774:
  .quad .Laot_word_entry_773
  .quad .Laot_word_name_774
  .quad aot_get_fw_62732d62797465
.section .rodata
.Laot_word_name_775:
  .byte 58
  .byte 98
  .byte 115
  .byte 45
  .byte 98
  .byte 121
  .byte 116
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_775:
  .quad .Laot_word_entry_774
  .quad .Laot_word_name_775
  .quad aot_set_fw_62732d62797465
.section .text
aot_get_fw_62642d736f75726365:
  leaq reg_fw_62642d736f75726365(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_62642d736f75726365:
  leaq reg_fw_62642d736f75726365(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_776:
  .byte 98
  .byte 100
  .byte 45
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_776:
  .quad .Laot_word_entry_775
  .quad .Laot_word_name_776
  .quad aot_get_fw_62642d736f75726365
.section .rodata
.Laot_word_name_777:
  .byte 58
  .byte 98
  .byte 100
  .byte 45
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_777:
  .quad .Laot_word_entry_776
  .quad .Laot_word_name_777
  .quad aot_set_fw_62642d736f75726365
.section .text
aot_get_fw_626b2d736f75726365:
  leaq reg_fw_626b2d736f75726365(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_626b2d736f75726365:
  leaq reg_fw_626b2d736f75726365(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_778:
  .byte 98
  .byte 107
  .byte 45
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_778:
  .quad .Laot_word_entry_777
  .quad .Laot_word_name_778
  .quad aot_get_fw_626b2d736f75726365
.section .rodata
.Laot_word_name_779:
  .byte 58
  .byte 98
  .byte 107
  .byte 45
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_779:
  .quad .Laot_word_entry_778
  .quad .Laot_word_name_779
  .quad aot_set_fw_626b2d736f75726365
.section .text
aot_get_fw_61722d6e616d65:
  leaq reg_fw_61722d6e616d65(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61722d6e616d65:
  leaq reg_fw_61722d6e616d65(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_780:
  .byte 97
  .byte 114
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_780:
  .quad .Laot_word_entry_779
  .quad .Laot_word_name_780
  .quad aot_get_fw_61722d6e616d65
.section .rodata
.Laot_word_name_781:
  .byte 58
  .byte 97
  .byte 114
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_781:
  .quad .Laot_word_entry_780
  .quad .Laot_word_name_781
  .quad aot_set_fw_61722d6e616d65
.section .text
aot_get_fw_61722d636f6465:
  leaq reg_fw_61722d636f6465(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_61722d636f6465:
  leaq reg_fw_61722d636f6465(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_782:
  .byte 97
  .byte 114
  .byte 45
  .byte 99
  .byte 111
  .byte 100
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_782:
  .quad .Laot_word_entry_781
  .quad .Laot_word_name_782
  .quad aot_get_fw_61722d636f6465
.section .rodata
.Laot_word_name_783:
  .byte 58
  .byte 97
  .byte 114
  .byte 45
  .byte 99
  .byte 111
  .byte 100
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_783:
  .quad .Laot_word_entry_782
  .quad .Laot_word_name_783
  .quad aot_set_fw_61722d636f6465
.section .text
aot_get_fw_616c2d736f75726365:
  leaq reg_fw_616c2d736f75726365(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_616c2d736f75726365:
  leaq reg_fw_616c2d736f75726365(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_784:
  .byte 97
  .byte 108
  .byte 45
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_784:
  .quad .Laot_word_entry_783
  .quad .Laot_word_name_784
  .quad aot_get_fw_616c2d736f75726365
.section .rodata
.Laot_word_name_785:
  .byte 58
  .byte 97
  .byte 108
  .byte 45
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_785:
  .quad .Laot_word_entry_784
  .quad .Laot_word_name_785
  .quad aot_set_fw_616c2d736f75726365
.section .text
aot_get_fw_616c2d636f756e74:
  leaq reg_fw_616c2d636f756e74(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_616c2d636f756e74:
  leaq reg_fw_616c2d636f756e74(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_786:
  .byte 97
  .byte 108
  .byte 45
  .byte 99
  .byte 111
  .byte 117
  .byte 110
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_786:
  .quad .Laot_word_entry_785
  .quad .Laot_word_name_786
  .quad aot_get_fw_616c2d636f756e74
.section .rodata
.Laot_word_name_787:
  .byte 58
  .byte 97
  .byte 108
  .byte 45
  .byte 99
  .byte 111
  .byte 117
  .byte 110
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_787:
  .quad .Laot_word_entry_786
  .quad .Laot_word_name_787
  .quad aot_set_fw_616c2d636f756e74
.section .text
aot_get_fw_616c2d696e6974:
  leaq reg_fw_616c2d696e6974(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_616c2d696e6974:
  leaq reg_fw_616c2d696e6974(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_788:
  .byte 97
  .byte 108
  .byte 45
  .byte 105
  .byte 110
  .byte 105
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_788:
  .quad .Laot_word_entry_787
  .quad .Laot_word_name_788
  .quad aot_get_fw_616c2d696e6974
.section .rodata
.Laot_word_name_789:
  .byte 58
  .byte 97
  .byte 108
  .byte 45
  .byte 105
  .byte 110
  .byte 105
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_789:
  .quad .Laot_word_entry_788
  .quad .Laot_word_name_789
  .quad aot_set_fw_616c2d696e6974
.section .text
aot_get_fw_616d2d6b6579:
  leaq reg_fw_616d2d6b6579(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_616d2d6b6579:
  leaq reg_fw_616d2d6b6579(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_790:
  .byte 97
  .byte 109
  .byte 45
  .byte 107
  .byte 101
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_790:
  .quad .Laot_word_entry_789
  .quad .Laot_word_name_790
  .quad aot_get_fw_616d2d6b6579
.section .rodata
.Laot_word_name_791:
  .byte 58
  .byte 97
  .byte 109
  .byte 45
  .byte 107
  .byte 101
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_791:
  .quad .Laot_word_entry_790
  .quad .Laot_word_name_791
  .quad aot_set_fw_616d2d6b6579
.section .text
aot_get_fw_6167:
  leaq reg_fw_6167(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6167:
  leaq reg_fw_6167(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_792:
  .byte 97
  .byte 103
  .byte 0
.section .data
.Laot_word_entry_792:
  .quad .Laot_word_entry_791
  .quad .Laot_word_name_792
  .quad aot_get_fw_6167
.section .rodata
.Laot_word_name_793:
  .byte 58
  .byte 97
  .byte 103
  .byte 0
.section .data
.Laot_word_entry_793:
  .quad .Laot_word_entry_792
  .quad .Laot_word_name_793
  .quad aot_set_fw_6167
.section .text
aot_get_fw_6169:
  leaq reg_fw_6169(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6169:
  leaq reg_fw_6169(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_794:
  .byte 97
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_794:
  .quad .Laot_word_entry_793
  .quad .Laot_word_name_794
  .quad aot_get_fw_6169
.section .rodata
.Laot_word_name_795:
  .byte 58
  .byte 97
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_795:
  .quad .Laot_word_entry_794
  .quad .Laot_word_name_795
  .quad aot_set_fw_6169
.section .text
aot_get_fw_616e:
  leaq reg_fw_616e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_616e:
  leaq reg_fw_616e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_796:
  .byte 97
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_796:
  .quad .Laot_word_entry_795
  .quad .Laot_word_name_796
  .quad aot_get_fw_616e
.section .rodata
.Laot_word_name_797:
  .byte 58
  .byte 97
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_797:
  .quad .Laot_word_entry_796
  .quad .Laot_word_name_797
  .quad aot_set_fw_616e
.section .text
aot_get_fw_6171:
  leaq reg_fw_6171(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6171:
  leaq reg_fw_6171(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_798:
  .byte 97
  .byte 113
  .byte 0
.section .data
.Laot_word_entry_798:
  .quad .Laot_word_entry_797
  .quad .Laot_word_name_798
  .quad aot_get_fw_6171
.section .rodata
.Laot_word_name_799:
  .byte 58
  .byte 97
  .byte 113
  .byte 0
.section .data
.Laot_word_entry_799:
  .quad .Laot_word_entry_798
  .quad .Laot_word_name_799
  .quad aot_set_fw_6171
.section .text
aot_get_fw_6173:
  leaq reg_fw_6173(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6173:
  leaq reg_fw_6173(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_800:
  .byte 97
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_800:
  .quad .Laot_word_entry_799
  .quad .Laot_word_name_800
  .quad aot_get_fw_6173
.section .rodata
.Laot_word_name_801:
  .byte 58
  .byte 97
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_801:
  .quad .Laot_word_entry_800
  .quad .Laot_word_name_801
  .quad aot_set_fw_6173
.section .text
aot_get_fw_6174:
  leaq reg_fw_6174(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6174:
  leaq reg_fw_6174(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_802:
  .byte 97
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_802:
  .quad .Laot_word_entry_801
  .quad .Laot_word_name_802
  .quad aot_get_fw_6174
.section .rodata
.Laot_word_name_803:
  .byte 58
  .byte 97
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_803:
  .quad .Laot_word_entry_802
  .quad .Laot_word_name_803
  .quad aot_set_fw_6174
.section .text
aot_get_fw_6178:
  leaq reg_fw_6178(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6178:
  leaq reg_fw_6178(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_804:
  .byte 97
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_804:
  .quad .Laot_word_entry_803
  .quad .Laot_word_name_804
  .quad aot_get_fw_6178
.section .rodata
.Laot_word_name_805:
  .byte 58
  .byte 97
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_805:
  .quad .Laot_word_entry_804
  .quad .Laot_word_name_805
  .quad aot_set_fw_6178
.section .text
aot_get_fw_6361:
  leaq reg_fw_6361(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6361:
  leaq reg_fw_6361(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_806:
  .byte 99
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_806:
  .quad .Laot_word_entry_805
  .quad .Laot_word_name_806
  .quad aot_get_fw_6361
.section .rodata
.Laot_word_name_807:
  .byte 58
  .byte 99
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_807:
  .quad .Laot_word_entry_806
  .quad .Laot_word_name_807
  .quad aot_set_fw_6361
.section .text
aot_get_fw_63616c632d616e73:
  leaq reg_fw_63616c632d616e73(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_63616c632d616e73:
  leaq reg_fw_63616c632d616e73(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_808:
  .byte 99
  .byte 97
  .byte 108
  .byte 99
  .byte 45
  .byte 97
  .byte 110
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_808:
  .quad .Laot_word_entry_807
  .quad .Laot_word_name_808
  .quad aot_get_fw_63616c632d616e73
.section .rodata
.Laot_word_name_809:
  .byte 58
  .byte 99
  .byte 97
  .byte 108
  .byte 99
  .byte 45
  .byte 97
  .byte 110
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_809:
  .quad .Laot_word_entry_808
  .quad .Laot_word_name_809
  .quad aot_set_fw_63616c632d616e73
.section .text
aot_get_fw_63616c632d63686172:
  leaq reg_fw_63616c632d63686172(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_63616c632d63686172:
  leaq reg_fw_63616c632d63686172(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_810:
  .byte 99
  .byte 97
  .byte 108
  .byte 99
  .byte 45
  .byte 99
  .byte 104
  .byte 97
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_810:
  .quad .Laot_word_entry_809
  .quad .Laot_word_name_810
  .quad aot_get_fw_63616c632d63686172
.section .rodata
.Laot_word_name_811:
  .byte 58
  .byte 99
  .byte 97
  .byte 108
  .byte 99
  .byte 45
  .byte 99
  .byte 104
  .byte 97
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_811:
  .quad .Laot_word_entry_810
  .quad .Laot_word_name_811
  .quad aot_set_fw_63616c632d63686172
.section .text
aot_get_fw_63616c632d69:
  leaq reg_fw_63616c632d69(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_63616c632d69:
  leaq reg_fw_63616c632d69(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_812:
  .byte 99
  .byte 97
  .byte 108
  .byte 99
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_812:
  .quad .Laot_word_entry_811
  .quad .Laot_word_name_812
  .quad aot_get_fw_63616c632d69
.section .rodata
.Laot_word_name_813:
  .byte 58
  .byte 99
  .byte 97
  .byte 108
  .byte 99
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_813:
  .quad .Laot_word_entry_812
  .quad .Laot_word_name_813
  .quad aot_set_fw_63616c632d69
.section .text
aot_get_fw_63616c632d6b6579:
  leaq reg_fw_63616c632d6b6579(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_63616c632d6b6579:
  leaq reg_fw_63616c632d6b6579(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_814:
  .byte 99
  .byte 97
  .byte 108
  .byte 99
  .byte 45
  .byte 107
  .byte 101
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_814:
  .quad .Laot_word_entry_813
  .quad .Laot_word_name_814
  .quad aot_get_fw_63616c632d6b6579
.section .rodata
.Laot_word_name_815:
  .byte 58
  .byte 99
  .byte 97
  .byte 108
  .byte 99
  .byte 45
  .byte 107
  .byte 101
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_815:
  .quad .Laot_word_entry_814
  .quad .Laot_word_name_815
  .quad aot_set_fw_63616c632d6b6579
.section .text
aot_get_fw_63616c632d6c656e:
  leaq reg_fw_63616c632d6c656e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_63616c632d6c656e:
  leaq reg_fw_63616c632d6c656e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_816:
  .byte 99
  .byte 97
  .byte 108
  .byte 99
  .byte 45
  .byte 108
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_816:
  .quad .Laot_word_entry_815
  .quad .Laot_word_name_816
  .quad aot_get_fw_63616c632d6c656e
.section .rodata
.Laot_word_name_817:
  .byte 58
  .byte 99
  .byte 97
  .byte 108
  .byte 99
  .byte 45
  .byte 108
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_817:
  .quad .Laot_word_entry_816
  .quad .Laot_word_name_817
  .quad aot_set_fw_63616c632d6c656e
.section .text
aot_get_fw_63616c632d70726576:
  leaq reg_fw_63616c632d70726576(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_63616c632d70726576:
  leaq reg_fw_63616c632d70726576(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_818:
  .byte 99
  .byte 97
  .byte 108
  .byte 99
  .byte 45
  .byte 112
  .byte 114
  .byte 101
  .byte 118
  .byte 0
.section .data
.Laot_word_entry_818:
  .quad .Laot_word_entry_817
  .quad .Laot_word_name_818
  .quad aot_get_fw_63616c632d70726576
.section .rodata
.Laot_word_name_819:
  .byte 58
  .byte 99
  .byte 97
  .byte 108
  .byte 99
  .byte 45
  .byte 112
  .byte 114
  .byte 101
  .byte 118
  .byte 0
.section .data
.Laot_word_entry_819:
  .quad .Laot_word_entry_818
  .quad .Laot_word_name_819
  .quad aot_set_fw_63616c632d70726576
.section .text
aot_get_fw_63616c632d707472:
  leaq reg_fw_63616c632d707472(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_63616c632d707472:
  leaq reg_fw_63616c632d707472(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_820:
  .byte 99
  .byte 97
  .byte 108
  .byte 99
  .byte 45
  .byte 112
  .byte 116
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_820:
  .quad .Laot_word_entry_819
  .quad .Laot_word_name_820
  .quad aot_get_fw_63616c632d707472
.section .rodata
.Laot_word_name_821:
  .byte 58
  .byte 99
  .byte 97
  .byte 108
  .byte 99
  .byte 45
  .byte 112
  .byte 116
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_821:
  .quad .Laot_word_entry_820
  .quad .Laot_word_name_821
  .quad aot_set_fw_63616c632d707472
.section .text
aot_get_fw_63616c632d7361766564:
  leaq reg_fw_63616c632d7361766564(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_63616c632d7361766564:
  leaq reg_fw_63616c632d7361766564(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_822:
  .byte 99
  .byte 97
  .byte 108
  .byte 99
  .byte 45
  .byte 115
  .byte 97
  .byte 118
  .byte 101
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_822:
  .quad .Laot_word_entry_821
  .quad .Laot_word_name_822
  .quad aot_get_fw_63616c632d7361766564
.section .rodata
.Laot_word_name_823:
  .byte 58
  .byte 99
  .byte 97
  .byte 108
  .byte 99
  .byte 45
  .byte 115
  .byte 97
  .byte 118
  .byte 101
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_823:
  .quad .Laot_word_entry_822
  .quad .Laot_word_name_823
  .quad aot_set_fw_63616c632d7361766564
.section .text
aot_get_fw_63616c632d7374617274:
  leaq reg_fw_63616c632d7374617274(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_63616c632d7374617274:
  leaq reg_fw_63616c632d7374617274(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_824:
  .byte 99
  .byte 97
  .byte 108
  .byte 99
  .byte 45
  .byte 115
  .byte 116
  .byte 97
  .byte 114
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_824:
  .quad .Laot_word_entry_823
  .quad .Laot_word_name_824
  .quad aot_get_fw_63616c632d7374617274
.section .rodata
.Laot_word_name_825:
  .byte 58
  .byte 99
  .byte 97
  .byte 108
  .byte 99
  .byte 45
  .byte 115
  .byte 116
  .byte 97
  .byte 114
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_825:
  .quad .Laot_word_entry_824
  .quad .Laot_word_name_825
  .quad aot_set_fw_63616c632d7374617274
.section .text
aot_get_fw_6368:
  leaq reg_fw_6368(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6368:
  leaq reg_fw_6368(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_826:
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_826:
  .quad .Laot_word_entry_825
  .quad .Laot_word_name_826
  .quad aot_get_fw_6368
.section .rodata
.Laot_word_name_827:
  .byte 58
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_827:
  .quad .Laot_word_entry_826
  .quad .Laot_word_name_827
  .quad aot_set_fw_6368
.section .text
aot_get_fw_63702d64617461:
  leaq reg_fw_63702d64617461(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_63702d64617461:
  leaq reg_fw_63702d64617461(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_828:
  .byte 99
  .byte 112
  .byte 45
  .byte 100
  .byte 97
  .byte 116
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_828:
  .quad .Laot_word_entry_827
  .quad .Laot_word_name_828
  .quad aot_get_fw_63702d64617461
.section .rodata
.Laot_word_name_829:
  .byte 58
  .byte 99
  .byte 112
  .byte 45
  .byte 100
  .byte 97
  .byte 116
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_829:
  .quad .Laot_word_entry_828
  .quad .Laot_word_name_829
  .quad aot_set_fw_63702d64617461
.section .text
aot_get_fw_63702d64657374:
  leaq reg_fw_63702d64657374(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_63702d64657374:
  leaq reg_fw_63702d64657374(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_830:
  .byte 99
  .byte 112
  .byte 45
  .byte 100
  .byte 101
  .byte 115
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_830:
  .quad .Laot_word_entry_829
  .quad .Laot_word_name_830
  .quad aot_get_fw_63702d64657374
.section .rodata
.Laot_word_name_831:
  .byte 58
  .byte 99
  .byte 112
  .byte 45
  .byte 100
  .byte 101
  .byte 115
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_831:
  .quad .Laot_word_entry_830
  .quad .Laot_word_name_831
  .quad aot_set_fw_63702d64657374
.section .text
aot_get_fw_63702d736f75726365:
  leaq reg_fw_63702d736f75726365(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_63702d736f75726365:
  leaq reg_fw_63702d736f75726365(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_832:
  .byte 99
  .byte 112
  .byte 45
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_832:
  .quad .Laot_word_entry_831
  .quad .Laot_word_name_832
  .quad aot_get_fw_63702d736f75726365
.section .rodata
.Laot_word_name_833:
  .byte 58
  .byte 99
  .byte 112
  .byte 45
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_833:
  .quad .Laot_word_entry_832
  .quad .Laot_word_name_833
  .quad aot_set_fw_63702d736f75726365
.section .text
aot_get_fw_6378:
  leaq reg_fw_6378(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6378:
  leaq reg_fw_6378(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_834:
  .byte 99
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_834:
  .quad .Laot_word_entry_833
  .quad .Laot_word_name_834
  .quad aot_get_fw_6378
.section .rodata
.Laot_word_name_835:
  .byte 58
  .byte 99
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_835:
  .quad .Laot_word_entry_834
  .quad .Laot_word_name_835
  .quad aot_set_fw_6378
.section .text
aot_get_fw_6463:
  leaq reg_fw_6463(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6463:
  leaq reg_fw_6463(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_836:
  .byte 100
  .byte 99
  .byte 0
.section .data
.Laot_word_entry_836:
  .quad .Laot_word_entry_835
  .quad .Laot_word_name_836
  .quad aot_get_fw_6463
.section .rodata
.Laot_word_name_837:
  .byte 58
  .byte 100
  .byte 99
  .byte 0
.section .data
.Laot_word_entry_837:
  .quad .Laot_word_entry_836
  .quad .Laot_word_name_837
  .quad aot_set_fw_6463
.section .text
aot_get_fw_64642d616869:
  leaq reg_fw_64642d616869(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_64642d616869:
  leaq reg_fw_64642d616869(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_838:
  .byte 100
  .byte 100
  .byte 45
  .byte 97
  .byte 104
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_838:
  .quad .Laot_word_entry_837
  .quad .Laot_word_name_838
  .quad aot_get_fw_64642d616869
.section .rodata
.Laot_word_name_839:
  .byte 58
  .byte 100
  .byte 100
  .byte 45
  .byte 97
  .byte 104
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_839:
  .quad .Laot_word_entry_838
  .quad .Laot_word_name_839
  .quad aot_set_fw_64642d616869
.section .text
aot_get_fw_64642d616c6f:
  leaq reg_fw_64642d616c6f(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_64642d616c6f:
  leaq reg_fw_64642d616c6f(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_840:
  .byte 100
  .byte 100
  .byte 45
  .byte 97
  .byte 108
  .byte 111
  .byte 0
.section .data
.Laot_word_entry_840:
  .quad .Laot_word_entry_839
  .quad .Laot_word_name_840
  .quad aot_get_fw_64642d616c6f
.section .rodata
.Laot_word_name_841:
  .byte 58
  .byte 100
  .byte 100
  .byte 45
  .byte 97
  .byte 108
  .byte 111
  .byte 0
.section .data
.Laot_word_entry_841:
  .quad .Laot_word_entry_840
  .quad .Laot_word_name_841
  .quad aot_set_fw_64642d616c6f
.section .text
aot_get_fw_64642d626869:
  leaq reg_fw_64642d626869(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_64642d626869:
  leaq reg_fw_64642d626869(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_842:
  .byte 100
  .byte 100
  .byte 45
  .byte 98
  .byte 104
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_842:
  .quad .Laot_word_entry_841
  .quad .Laot_word_name_842
  .quad aot_get_fw_64642d626869
.section .rodata
.Laot_word_name_843:
  .byte 58
  .byte 100
  .byte 100
  .byte 45
  .byte 98
  .byte 104
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_843:
  .quad .Laot_word_entry_842
  .quad .Laot_word_name_843
  .quad aot_set_fw_64642d626869
.section .text
aot_get_fw_64642d626c6f:
  leaq reg_fw_64642d626c6f(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_64642d626c6f:
  leaq reg_fw_64642d626c6f(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_844:
  .byte 100
  .byte 100
  .byte 45
  .byte 98
  .byte 108
  .byte 111
  .byte 0
.section .data
.Laot_word_entry_844:
  .quad .Laot_word_entry_843
  .quad .Laot_word_name_844
  .quad aot_get_fw_64642d626c6f
.section .rodata
.Laot_word_name_845:
  .byte 58
  .byte 100
  .byte 100
  .byte 45
  .byte 98
  .byte 108
  .byte 111
  .byte 0
.section .data
.Laot_word_entry_845:
  .quad .Laot_word_entry_844
  .quad .Laot_word_name_845
  .quad aot_set_fw_64642d626c6f
.section .text
aot_get_fw_64642d6869:
  leaq reg_fw_64642d6869(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_64642d6869:
  leaq reg_fw_64642d6869(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_846:
  .byte 100
  .byte 100
  .byte 45
  .byte 104
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_846:
  .quad .Laot_word_entry_845
  .quad .Laot_word_name_846
  .quad aot_get_fw_64642d6869
.section .rodata
.Laot_word_name_847:
  .byte 58
  .byte 100
  .byte 100
  .byte 45
  .byte 104
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_847:
  .quad .Laot_word_entry_846
  .quad .Laot_word_name_847
  .quad aot_set_fw_64642d6869
.section .text
aot_get_fw_64642d6c6f:
  leaq reg_fw_64642d6c6f(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_64642d6c6f:
  leaq reg_fw_64642d6c6f(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_848:
  .byte 100
  .byte 100
  .byte 45
  .byte 108
  .byte 111
  .byte 0
.section .data
.Laot_word_entry_848:
  .quad .Laot_word_entry_847
  .quad .Laot_word_name_848
  .quad aot_get_fw_64642d6c6f
.section .rodata
.Laot_word_name_849:
  .byte 58
  .byte 100
  .byte 100
  .byte 45
  .byte 108
  .byte 111
  .byte 0
.section .data
.Laot_word_entry_849:
  .quad .Laot_word_entry_848
  .quad .Laot_word_name_849
  .quad aot_set_fw_64642d6c6f
.section .text
aot_get_fw_64642d7363616c65:
  leaq reg_fw_64642d7363616c65(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_64642d7363616c65:
  leaq reg_fw_64642d7363616c65(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_850:
  .byte 100
  .byte 100
  .byte 45
  .byte 115
  .byte 99
  .byte 97
  .byte 108
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_850:
  .quad .Laot_word_entry_849
  .quad .Laot_word_name_850
  .quad aot_get_fw_64642d7363616c65
.section .rodata
.Laot_word_name_851:
  .byte 58
  .byte 100
  .byte 100
  .byte 45
  .byte 115
  .byte 99
  .byte 97
  .byte 108
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_851:
  .quad .Laot_word_entry_850
  .quad .Laot_word_name_851
  .quad aot_set_fw_64642d7363616c65
.section .text
aot_get_fw_6469:
  leaq reg_fw_6469(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6469:
  leaq reg_fw_6469(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_852:
  .byte 100
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_852:
  .quad .Laot_word_entry_851
  .quad .Laot_word_name_852
  .quad aot_get_fw_6469
.section .rodata
.Laot_word_name_853:
  .byte 58
  .byte 100
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_853:
  .quad .Laot_word_entry_852
  .quad .Laot_word_name_853
  .quad aot_set_fw_6469
.section .text
aot_get_fw_656469742d63757272656e74:
  leaq reg_fw_656469742d63757272656e74(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_656469742d63757272656e74:
  leaq reg_fw_656469742d63757272656e74(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_854:
  .byte 101
  .byte 100
  .byte 105
  .byte 116
  .byte 45
  .byte 99
  .byte 117
  .byte 114
  .byte 114
  .byte 101
  .byte 110
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_854:
  .quad .Laot_word_entry_853
  .quad .Laot_word_name_854
  .quad aot_get_fw_656469742d63757272656e74
.section .rodata
.Laot_word_name_855:
  .byte 58
  .byte 101
  .byte 100
  .byte 105
  .byte 116
  .byte 45
  .byte 99
  .byte 117
  .byte 114
  .byte 114
  .byte 101
  .byte 110
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_855:
  .quad .Laot_word_entry_854
  .quad .Laot_word_name_855
  .quad aot_set_fw_656469742d63757272656e74
.section .text
aot_get_fw_656469742d6e616d65:
  leaq reg_fw_656469742d6e616d65(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_656469742d6e616d65:
  leaq reg_fw_656469742d6e616d65(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_856:
  .byte 101
  .byte 100
  .byte 105
  .byte 116
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_856:
  .quad .Laot_word_entry_855
  .quad .Laot_word_name_856
  .quad aot_get_fw_656469742d6e616d65
.section .rodata
.Laot_word_name_857:
  .byte 58
  .byte 101
  .byte 100
  .byte 105
  .byte 116
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_857:
  .quad .Laot_word_entry_856
  .quad .Laot_word_name_857
  .quad aot_set_fw_656469742d6e616d65
.section .text
aot_get_fw_6566:
  leaq reg_fw_6566(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6566:
  leaq reg_fw_6566(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_858:
  .byte 101
  .byte 102
  .byte 0
.section .data
.Laot_word_entry_858:
  .quad .Laot_word_entry_857
  .quad .Laot_word_name_858
  .quad aot_get_fw_6566
.section .rodata
.Laot_word_name_859:
  .byte 58
  .byte 101
  .byte 102
  .byte 0
.section .data
.Laot_word_entry_859:
  .quad .Laot_word_entry_858
  .quad .Laot_word_name_859
  .quad aot_set_fw_6566
.section .text
aot_get_fw_6569:
  leaq reg_fw_6569(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6569:
  leaq reg_fw_6569(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_860:
  .byte 101
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_860:
  .quad .Laot_word_entry_859
  .quad .Laot_word_name_860
  .quad aot_get_fw_6569
.section .rodata
.Laot_word_name_861:
  .byte 58
  .byte 101
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_861:
  .quad .Laot_word_entry_860
  .quad .Laot_word_name_861
  .quad aot_set_fw_6569
.section .text
aot_get_fw_656b:
  leaq reg_fw_656b(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_656b:
  leaq reg_fw_656b(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_862:
  .byte 101
  .byte 107
  .byte 0
.section .data
.Laot_word_entry_862:
  .quad .Laot_word_entry_861
  .quad .Laot_word_name_862
  .quad aot_get_fw_656b
.section .rodata
.Laot_word_name_863:
  .byte 58
  .byte 101
  .byte 107
  .byte 0
.section .data
.Laot_word_entry_863:
  .quad .Laot_word_entry_862
  .quad .Laot_word_name_863
  .quad aot_set_fw_656b
.section .text
aot_get_fw_656e:
  leaq reg_fw_656e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_656e:
  leaq reg_fw_656e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_864:
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_864:
  .quad .Laot_word_entry_863
  .quad .Laot_word_name_864
  .quad aot_get_fw_656e
.section .rodata
.Laot_word_name_865:
  .byte 58
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_865:
  .quad .Laot_word_entry_864
  .quad .Laot_word_name_865
  .quad aot_set_fw_656e
.section .text
aot_get_fw_6573:
  leaq reg_fw_6573(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6573:
  leaq reg_fw_6573(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_866:
  .byte 101
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_866:
  .quad .Laot_word_entry_865
  .quad .Laot_word_name_866
  .quad aot_get_fw_6573
.section .rodata
.Laot_word_name_867:
  .byte 58
  .byte 101
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_867:
  .quad .Laot_word_entry_866
  .quad .Laot_word_name_867
  .quad aot_set_fw_6573
.section .text
aot_get_fw_6574:
  leaq reg_fw_6574(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6574:
  leaq reg_fw_6574(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_868:
  .byte 101
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_868:
  .quad .Laot_word_entry_867
  .quad .Laot_word_name_868
  .quad aot_get_fw_6574
.section .rodata
.Laot_word_name_869:
  .byte 58
  .byte 101
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_869:
  .quad .Laot_word_entry_868
  .quad .Laot_word_name_869
  .quad aot_set_fw_6574
.section .text
aot_get_fw_6578:
  leaq reg_fw_6578(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6578:
  leaq reg_fw_6578(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_870:
  .byte 101
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_870:
  .quad .Laot_word_entry_869
  .quad .Laot_word_name_870
  .quad aot_get_fw_6578
.section .rodata
.Laot_word_name_871:
  .byte 58
  .byte 101
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_871:
  .quad .Laot_word_entry_870
  .quad .Laot_word_name_871
  .quad aot_set_fw_6578
.section .text
aot_get_fw_6661:
  leaq reg_fw_6661(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6661:
  leaq reg_fw_6661(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_872:
  .byte 102
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_872:
  .quad .Laot_word_entry_871
  .quad .Laot_word_name_872
  .quad aot_get_fw_6661
.section .rodata
.Laot_word_name_873:
  .byte 58
  .byte 102
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_873:
  .quad .Laot_word_entry_872
  .quad .Laot_word_name_873
  .quad aot_set_fw_6661
.section .text
aot_get_fw_6662:
  leaq reg_fw_6662(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6662:
  leaq reg_fw_6662(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_874:
  .byte 102
  .byte 98
  .byte 0
.section .data
.Laot_word_entry_874:
  .quad .Laot_word_entry_873
  .quad .Laot_word_name_874
  .quad aot_get_fw_6662
.section .rodata
.Laot_word_name_875:
  .byte 58
  .byte 102
  .byte 98
  .byte 0
.section .data
.Laot_word_entry_875:
  .quad .Laot_word_entry_874
  .quad .Laot_word_name_875
  .quad aot_set_fw_6662
.section .text
aot_get_fw_6663:
  leaq reg_fw_6663(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6663:
  leaq reg_fw_6663(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_876:
  .byte 102
  .byte 99
  .byte 0
.section .data
.Laot_word_entry_876:
  .quad .Laot_word_entry_875
  .quad .Laot_word_name_876
  .quad aot_get_fw_6663
.section .rodata
.Laot_word_name_877:
  .byte 58
  .byte 102
  .byte 99
  .byte 0
.section .data
.Laot_word_entry_877:
  .quad .Laot_word_entry_876
  .quad .Laot_word_name_877
  .quad aot_set_fw_6663
.section .text
aot_get_fw_66636f6c6f72:
  leaq reg_fw_66636f6c6f72(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_66636f6c6f72:
  leaq reg_fw_66636f6c6f72(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_878:
  .byte 102
  .byte 99
  .byte 111
  .byte 108
  .byte 111
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_878:
  .quad .Laot_word_entry_877
  .quad .Laot_word_name_878
  .quad aot_get_fw_66636f6c6f72
.section .rodata
.Laot_word_name_879:
  .byte 58
  .byte 102
  .byte 99
  .byte 111
  .byte 108
  .byte 111
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_879:
  .quad .Laot_word_entry_878
  .quad .Laot_word_name_879
  .quad aot_set_fw_66636f6c6f72
.section .text
aot_get_fw_6664:
  leaq reg_fw_6664(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6664:
  leaq reg_fw_6664(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_880:
  .byte 102
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_880:
  .quad .Laot_word_entry_879
  .quad .Laot_word_name_880
  .quad aot_get_fw_6664
.section .rodata
.Laot_word_name_881:
  .byte 58
  .byte 102
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_881:
  .quad .Laot_word_entry_880
  .quad .Laot_word_name_881
  .quad aot_set_fw_6664
.section .text
aot_get_fw_666b:
  leaq reg_fw_666b(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_666b:
  leaq reg_fw_666b(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_882:
  .byte 102
  .byte 107
  .byte 0
.section .data
.Laot_word_entry_882:
  .quad .Laot_word_entry_881
  .quad .Laot_word_name_882
  .quad aot_get_fw_666b
.section .rodata
.Laot_word_name_883:
  .byte 58
  .byte 102
  .byte 107
  .byte 0
.section .data
.Laot_word_entry_883:
  .quad .Laot_word_entry_882
  .quad .Laot_word_name_883
  .quad aot_set_fw_666b
.section .text
aot_get_fw_666c:
  leaq reg_fw_666c(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_666c:
  leaq reg_fw_666c(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_884:
  .byte 102
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_884:
  .quad .Laot_word_entry_883
  .quad .Laot_word_name_884
  .quad aot_get_fw_666c
.section .rodata
.Laot_word_name_885:
  .byte 58
  .byte 102
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_885:
  .quad .Laot_word_entry_884
  .quad .Laot_word_name_885
  .quad aot_set_fw_666c
.section .text
aot_get_fw_666e:
  leaq reg_fw_666e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_666e:
  leaq reg_fw_666e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_886:
  .byte 102
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_886:
  .quad .Laot_word_entry_885
  .quad .Laot_word_name_886
  .quad aot_get_fw_666e
.section .rodata
.Laot_word_name_887:
  .byte 58
  .byte 102
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_887:
  .quad .Laot_word_entry_886
  .quad .Laot_word_name_887
  .quad aot_set_fw_666e
.section .text
aot_get_fw_6670:
  leaq reg_fw_6670(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6670:
  leaq reg_fw_6670(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_888:
  .byte 102
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_888:
  .quad .Laot_word_entry_887
  .quad .Laot_word_name_888
  .quad aot_get_fw_6670
.section .rodata
.Laot_word_name_889:
  .byte 58
  .byte 102
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_889:
  .quad .Laot_word_entry_888
  .quad .Laot_word_name_889
  .quad aot_set_fw_6670
.section .text
aot_get_fw_6671:
  leaq reg_fw_6671(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6671:
  leaq reg_fw_6671(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_890:
  .byte 102
  .byte 113
  .byte 0
.section .data
.Laot_word_entry_890:
  .quad .Laot_word_entry_889
  .quad .Laot_word_name_890
  .quad aot_get_fw_6671
.section .rodata
.Laot_word_name_891:
  .byte 58
  .byte 102
  .byte 113
  .byte 0
.section .data
.Laot_word_entry_891:
  .quad .Laot_word_entry_890
  .quad .Laot_word_name_891
  .quad aot_set_fw_6671
.section .text
aot_get_fw_6672:
  leaq reg_fw_6672(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6672:
  leaq reg_fw_6672(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_892:
  .byte 102
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_892:
  .quad .Laot_word_entry_891
  .quad .Laot_word_name_892
  .quad aot_get_fw_6672
.section .rodata
.Laot_word_name_893:
  .byte 58
  .byte 102
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_893:
  .quad .Laot_word_entry_892
  .quad .Laot_word_name_893
  .quad aot_set_fw_6672
.section .text
aot_get_fw_66722d636f6c:
  leaq reg_fw_66722d636f6c(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_66722d636f6c:
  leaq reg_fw_66722d636f6c(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_894:
  .byte 102
  .byte 114
  .byte 45
  .byte 99
  .byte 111
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_894:
  .quad .Laot_word_entry_893
  .quad .Laot_word_name_894
  .quad aot_get_fw_66722d636f6c
.section .rodata
.Laot_word_name_895:
  .byte 58
  .byte 102
  .byte 114
  .byte 45
  .byte 99
  .byte 111
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_895:
  .quad .Laot_word_entry_894
  .quad .Laot_word_name_895
  .quad aot_set_fw_66722d636f6c
.section .text
aot_get_fw_66722d636f6c6f72:
  leaq reg_fw_66722d636f6c6f72(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_66722d636f6c6f72:
  leaq reg_fw_66722d636f6c6f72(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_896:
  .byte 102
  .byte 114
  .byte 45
  .byte 99
  .byte 111
  .byte 108
  .byte 111
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_896:
  .quad .Laot_word_entry_895
  .quad .Laot_word_name_896
  .quad aot_get_fw_66722d636f6c6f72
.section .rodata
.Laot_word_name_897:
  .byte 58
  .byte 102
  .byte 114
  .byte 45
  .byte 99
  .byte 111
  .byte 108
  .byte 111
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_897:
  .quad .Laot_word_entry_896
  .quad .Laot_word_name_897
  .quad aot_set_fw_66722d636f6c6f72
.section .text
aot_get_fw_66722d686569676874:
  leaq reg_fw_66722d686569676874(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_66722d686569676874:
  leaq reg_fw_66722d686569676874(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_898:
  .byte 102
  .byte 114
  .byte 45
  .byte 104
  .byte 101
  .byte 105
  .byte 103
  .byte 104
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_898:
  .quad .Laot_word_entry_897
  .quad .Laot_word_name_898
  .quad aot_get_fw_66722d686569676874
.section .rodata
.Laot_word_name_899:
  .byte 58
  .byte 102
  .byte 114
  .byte 45
  .byte 104
  .byte 101
  .byte 105
  .byte 103
  .byte 104
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_899:
  .quad .Laot_word_entry_898
  .quad .Laot_word_name_899
  .quad aot_set_fw_66722d686569676874
.section .text
aot_get_fw_66722d726f77:
  leaq reg_fw_66722d726f77(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_66722d726f77:
  leaq reg_fw_66722d726f77(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_900:
  .byte 102
  .byte 114
  .byte 45
  .byte 114
  .byte 111
  .byte 119
  .byte 0
.section .data
.Laot_word_entry_900:
  .quad .Laot_word_entry_899
  .quad .Laot_word_name_900
  .quad aot_get_fw_66722d726f77
.section .rodata
.Laot_word_name_901:
  .byte 58
  .byte 102
  .byte 114
  .byte 45
  .byte 114
  .byte 111
  .byte 119
  .byte 0
.section .data
.Laot_word_entry_901:
  .quad .Laot_word_entry_900
  .quad .Laot_word_name_901
  .quad aot_set_fw_66722d726f77
.section .text
aot_get_fw_66722d7769647468:
  leaq reg_fw_66722d7769647468(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_66722d7769647468:
  leaq reg_fw_66722d7769647468(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_902:
  .byte 102
  .byte 114
  .byte 45
  .byte 119
  .byte 105
  .byte 100
  .byte 116
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_902:
  .quad .Laot_word_entry_901
  .quad .Laot_word_name_902
  .quad aot_get_fw_66722d7769647468
.section .rodata
.Laot_word_name_903:
  .byte 58
  .byte 102
  .byte 114
  .byte 45
  .byte 119
  .byte 105
  .byte 100
  .byte 116
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_903:
  .quad .Laot_word_entry_902
  .quad .Laot_word_name_903
  .quad aot_set_fw_66722d7769647468
.section .text
aot_get_fw_66722d78:
  leaq reg_fw_66722d78(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_66722d78:
  leaq reg_fw_66722d78(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_904:
  .byte 102
  .byte 114
  .byte 45
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_904:
  .quad .Laot_word_entry_903
  .quad .Laot_word_name_904
  .quad aot_get_fw_66722d78
.section .rodata
.Laot_word_name_905:
  .byte 58
  .byte 102
  .byte 114
  .byte 45
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_905:
  .quad .Laot_word_entry_904
  .quad .Laot_word_name_905
  .quad aot_set_fw_66722d78
.section .text
aot_get_fw_66722d79:
  leaq reg_fw_66722d79(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_66722d79:
  leaq reg_fw_66722d79(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_906:
  .byte 102
  .byte 114
  .byte 45
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_906:
  .quad .Laot_word_entry_905
  .quad .Laot_word_name_906
  .quad aot_get_fw_66722d79
.section .rodata
.Laot_word_name_907:
  .byte 58
  .byte 102
  .byte 114
  .byte 45
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_907:
  .quad .Laot_word_entry_906
  .quad .Laot_word_name_907
  .quad aot_set_fw_66722d79
.section .text
aot_get_fw_6674:
  leaq reg_fw_6674(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6674:
  leaq reg_fw_6674(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_908:
  .byte 102
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_908:
  .quad .Laot_word_entry_907
  .quad .Laot_word_name_908
  .quad aot_get_fw_6674
.section .rodata
.Laot_word_name_909:
  .byte 58
  .byte 102
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_909:
  .quad .Laot_word_entry_908
  .quad .Laot_word_name_909
  .quad aot_set_fw_6674
.section .text
aot_get_fw_6675:
  leaq reg_fw_6675(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6675:
  leaq reg_fw_6675(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_910:
  .byte 102
  .byte 117
  .byte 0
.section .data
.Laot_word_entry_910:
  .quad .Laot_word_entry_909
  .quad .Laot_word_name_910
  .quad aot_get_fw_6675
.section .rodata
.Laot_word_name_911:
  .byte 58
  .byte 102
  .byte 117
  .byte 0
.section .data
.Laot_word_entry_911:
  .quad .Laot_word_entry_910
  .quad .Laot_word_name_911
  .quad aot_set_fw_6675
.section .text
aot_get_fw_6676:
  leaq reg_fw_6676(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6676:
  leaq reg_fw_6676(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_912:
  .byte 102
  .byte 118
  .byte 0
.section .data
.Laot_word_entry_912:
  .quad .Laot_word_entry_911
  .quad .Laot_word_name_912
  .quad aot_get_fw_6676
.section .rodata
.Laot_word_name_913:
  .byte 58
  .byte 102
  .byte 118
  .byte 0
.section .data
.Laot_word_entry_913:
  .quad .Laot_word_entry_912
  .quad .Laot_word_name_913
  .quad aot_set_fw_6676
.section .text
aot_get_fw_6678:
  leaq reg_fw_6678(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6678:
  leaq reg_fw_6678(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_914:
  .byte 102
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_914:
  .quad .Laot_word_entry_913
  .quad .Laot_word_name_914
  .quad aot_get_fw_6678
.section .rodata
.Laot_word_name_915:
  .byte 58
  .byte 102
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_915:
  .quad .Laot_word_entry_914
  .quad .Laot_word_name_915
  .quad aot_set_fw_6678
.section .text
aot_get_fw_667863:
  leaq reg_fw_667863(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_667863:
  leaq reg_fw_667863(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_916:
  .byte 102
  .byte 120
  .byte 99
  .byte 0
.section .data
.Laot_word_entry_916:
  .quad .Laot_word_entry_915
  .quad .Laot_word_name_916
  .quad aot_get_fw_667863
.section .rodata
.Laot_word_name_917:
  .byte 58
  .byte 102
  .byte 120
  .byte 99
  .byte 0
.section .data
.Laot_word_entry_917:
  .quad .Laot_word_entry_916
  .quad .Laot_word_name_917
  .quad aot_set_fw_667863
.section .text
aot_get_fw_66786c:
  leaq reg_fw_66786c(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_66786c:
  leaq reg_fw_66786c(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_918:
  .byte 102
  .byte 120
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_918:
  .quad .Laot_word_entry_917
  .quad .Laot_word_name_918
  .quad aot_get_fw_66786c
.section .rodata
.Laot_word_name_919:
  .byte 58
  .byte 102
  .byte 120
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_919:
  .quad .Laot_word_entry_918
  .quad .Laot_word_name_919
  .quad aot_set_fw_66786c
.section .text
aot_get_fw_667872:
  leaq reg_fw_667872(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_667872:
  leaq reg_fw_667872(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_920:
  .byte 102
  .byte 120
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_920:
  .quad .Laot_word_entry_919
  .quad .Laot_word_name_920
  .quad aot_get_fw_667872
.section .rodata
.Laot_word_name_921:
  .byte 58
  .byte 102
  .byte 120
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_921:
  .quad .Laot_word_entry_920
  .quad .Laot_word_name_921
  .quad aot_set_fw_667872
.section .text
aot_get_fw_6679:
  leaq reg_fw_6679(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6679:
  leaq reg_fw_6679(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_922:
  .byte 102
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_922:
  .quad .Laot_word_entry_921
  .quad .Laot_word_name_922
  .quad aot_get_fw_6679
.section .rodata
.Laot_word_name_923:
  .byte 58
  .byte 102
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_923:
  .quad .Laot_word_entry_922
  .quad .Laot_word_name_923
  .quad aot_set_fw_6679
.section .text
aot_get_fw_667962:
  leaq reg_fw_667962(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_667962:
  leaq reg_fw_667962(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_924:
  .byte 102
  .byte 121
  .byte 98
  .byte 0
.section .data
.Laot_word_entry_924:
  .quad .Laot_word_entry_923
  .quad .Laot_word_name_924
  .quad aot_get_fw_667962
.section .rodata
.Laot_word_name_925:
  .byte 58
  .byte 102
  .byte 121
  .byte 98
  .byte 0
.section .data
.Laot_word_entry_925:
  .quad .Laot_word_entry_924
  .quad .Laot_word_name_925
  .quad aot_set_fw_667962
.section .text
aot_get_fw_667963:
  leaq reg_fw_667963(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_667963:
  leaq reg_fw_667963(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_926:
  .byte 102
  .byte 121
  .byte 99
  .byte 0
.section .data
.Laot_word_entry_926:
  .quad .Laot_word_entry_925
  .quad .Laot_word_name_926
  .quad aot_get_fw_667963
.section .rodata
.Laot_word_name_927:
  .byte 58
  .byte 102
  .byte 121
  .byte 99
  .byte 0
.section .data
.Laot_word_entry_927:
  .quad .Laot_word_entry_926
  .quad .Laot_word_name_927
  .quad aot_set_fw_667963
.section .text
aot_get_fw_667974:
  leaq reg_fw_667974(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_667974:
  leaq reg_fw_667974(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_928:
  .byte 102
  .byte 121
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_928:
  .quad .Laot_word_entry_927
  .quad .Laot_word_name_928
  .quad aot_get_fw_667974
.section .rodata
.Laot_word_name_929:
  .byte 58
  .byte 102
  .byte 121
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_929:
  .quad .Laot_word_entry_928
  .quad .Laot_word_name_929
  .quad aot_set_fw_667974
.section .text
aot_get_fw_696861:
  leaq reg_fw_696861(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_696861:
  leaq reg_fw_696861(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_930:
  .byte 105
  .byte 104
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_930:
  .quad .Laot_word_entry_929
  .quad .Laot_word_name_930
  .quad aot_get_fw_696861
.section .rodata
.Laot_word_name_931:
  .byte 58
  .byte 105
  .byte 104
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_931:
  .quad .Laot_word_entry_930
  .quad .Laot_word_name_931
  .quad aot_set_fw_696861
.section .text
aot_get_fw_696862:
  leaq reg_fw_696862(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_696862:
  leaq reg_fw_696862(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_932:
  .byte 105
  .byte 104
  .byte 98
  .byte 0
.section .data
.Laot_word_entry_932:
  .quad .Laot_word_entry_931
  .quad .Laot_word_name_932
  .quad aot_get_fw_696862
.section .rodata
.Laot_word_name_933:
  .byte 58
  .byte 105
  .byte 104
  .byte 98
  .byte 0
.section .data
.Laot_word_entry_933:
  .quad .Laot_word_entry_932
  .quad .Laot_word_name_933
  .quad aot_set_fw_696862
.section .text
aot_get_fw_696c61:
  leaq reg_fw_696c61(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_696c61:
  leaq reg_fw_696c61(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_934:
  .byte 105
  .byte 108
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_934:
  .quad .Laot_word_entry_933
  .quad .Laot_word_name_934
  .quad aot_get_fw_696c61
.section .rodata
.Laot_word_name_935:
  .byte 58
  .byte 105
  .byte 108
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_935:
  .quad .Laot_word_entry_934
  .quad .Laot_word_name_935
  .quad aot_set_fw_696c61
.section .text
aot_get_fw_696c62:
  leaq reg_fw_696c62(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_696c62:
  leaq reg_fw_696c62(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_936:
  .byte 105
  .byte 108
  .byte 98
  .byte 0
.section .data
.Laot_word_entry_936:
  .quad .Laot_word_entry_935
  .quad .Laot_word_name_936
  .quad aot_get_fw_696c62
.section .rodata
.Laot_word_name_937:
  .byte 58
  .byte 105
  .byte 108
  .byte 98
  .byte 0
.section .data
.Laot_word_entry_937:
  .quad .Laot_word_entry_936
  .quad .Laot_word_name_937
  .quad aot_set_fw_696c62
.section .text
aot_get_fw_697031:
  leaq reg_fw_697031(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_697031:
  leaq reg_fw_697031(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_938:
  .byte 105
  .byte 112
  .byte 49
  .byte 0
.section .data
.Laot_word_entry_938:
  .quad .Laot_word_entry_937
  .quad .Laot_word_name_938
  .quad aot_get_fw_697031
.section .rodata
.Laot_word_name_939:
  .byte 58
  .byte 105
  .byte 112
  .byte 49
  .byte 0
.section .data
.Laot_word_entry_939:
  .quad .Laot_word_entry_938
  .quad .Laot_word_name_939
  .quad aot_set_fw_697031
.section .text
aot_get_fw_697032:
  leaq reg_fw_697032(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_697032:
  leaq reg_fw_697032(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_940:
  .byte 105
  .byte 112
  .byte 50
  .byte 0
.section .data
.Laot_word_entry_940:
  .quad .Laot_word_entry_939
  .quad .Laot_word_name_940
  .quad aot_get_fw_697032
.section .rodata
.Laot_word_name_941:
  .byte 58
  .byte 105
  .byte 112
  .byte 50
  .byte 0
.section .data
.Laot_word_entry_941:
  .quad .Laot_word_entry_940
  .quad .Laot_word_name_941
  .quad aot_set_fw_697032
.section .text
aot_get_fw_697033:
  leaq reg_fw_697033(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_697033:
  leaq reg_fw_697033(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_942:
  .byte 105
  .byte 112
  .byte 51
  .byte 0
.section .data
.Laot_word_entry_942:
  .quad .Laot_word_entry_941
  .quad .Laot_word_name_942
  .quad aot_get_fw_697033
.section .rodata
.Laot_word_name_943:
  .byte 58
  .byte 105
  .byte 112
  .byte 51
  .byte 0
.section .data
.Laot_word_entry_943:
  .quad .Laot_word_entry_942
  .quad .Laot_word_name_943
  .quad aot_set_fw_697033
.section .text
aot_get_fw_697034:
  leaq reg_fw_697034(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_697034:
  leaq reg_fw_697034(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_944:
  .byte 105
  .byte 112
  .byte 52
  .byte 0
.section .data
.Laot_word_entry_944:
  .quad .Laot_word_entry_943
  .quad .Laot_word_name_944
  .quad aot_get_fw_697034
.section .rodata
.Laot_word_name_945:
  .byte 58
  .byte 105
  .byte 112
  .byte 52
  .byte 0
.section .data
.Laot_word_entry_945:
  .quad .Laot_word_entry_944
  .quad .Laot_word_name_945
  .quad aot_set_fw_697034
.section .text
aot_get_fw_697668:
  leaq reg_fw_697668(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_697668:
  leaq reg_fw_697668(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_946:
  .byte 105
  .byte 118
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_946:
  .quad .Laot_word_entry_945
  .quad .Laot_word_name_946
  .quad aot_get_fw_697668
.section .rodata
.Laot_word_name_947:
  .byte 58
  .byte 105
  .byte 118
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_947:
  .quad .Laot_word_entry_946
  .quad .Laot_word_name_947
  .quad aot_set_fw_697668
.section .text
aot_get_fw_69766c:
  leaq reg_fw_69766c(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_69766c:
  leaq reg_fw_69766c(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_948:
  .byte 105
  .byte 118
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_948:
  .quad .Laot_word_entry_947
  .quad .Laot_word_name_948
  .quad aot_get_fw_69766c
.section .rodata
.Laot_word_name_949:
  .byte 58
  .byte 105
  .byte 118
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_949:
  .quad .Laot_word_entry_948
  .quad .Laot_word_name_949
  .quad aot_set_fw_69766c
.section .text
aot_get_fw_6c61756e63682d636f6465:
  leaq reg_fw_6c61756e63682d636f6465(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c61756e63682d636f6465:
  leaq reg_fw_6c61756e63682d636f6465(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_950:
  .byte 108
  .byte 97
  .byte 117
  .byte 110
  .byte 99
  .byte 104
  .byte 45
  .byte 99
  .byte 111
  .byte 100
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_950:
  .quad .Laot_word_entry_949
  .quad .Laot_word_name_950
  .quad aot_get_fw_6c61756e63682d636f6465
.section .rodata
.Laot_word_name_951:
  .byte 58
  .byte 108
  .byte 97
  .byte 117
  .byte 110
  .byte 99
  .byte 104
  .byte 45
  .byte 99
  .byte 111
  .byte 100
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_951:
  .quad .Laot_word_entry_950
  .quad .Laot_word_name_951
  .quad aot_set_fw_6c61756e63682d636f6465
.section .text
aot_get_fw_6c61756e63682d6e616d65:
  leaq reg_fw_6c61756e63682d6e616d65(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c61756e63682d6e616d65:
  leaq reg_fw_6c61756e63682d6e616d65(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_952:
  .byte 108
  .byte 97
  .byte 117
  .byte 110
  .byte 99
  .byte 104
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_952:
  .quad .Laot_word_entry_951
  .quad .Laot_word_name_952
  .quad aot_get_fw_6c61756e63682d6e616d65
.section .rodata
.Laot_word_name_953:
  .byte 58
  .byte 108
  .byte 97
  .byte 117
  .byte 110
  .byte 99
  .byte 104
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_953:
  .quad .Laot_word_entry_952
  .quad .Laot_word_name_953
  .quad aot_set_fw_6c61756e63682d6e616d65
.section .text
aot_get_fw_6c63:
  leaq reg_fw_6c63(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c63:
  leaq reg_fw_6c63(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_954:
  .byte 108
  .byte 99
  .byte 0
.section .data
.Laot_word_entry_954:
  .quad .Laot_word_entry_953
  .quad .Laot_word_name_954
  .quad aot_get_fw_6c63
.section .rodata
.Laot_word_name_955:
  .byte 58
  .byte 108
  .byte 99
  .byte 0
.section .data
.Laot_word_entry_955:
  .quad .Laot_word_entry_954
  .quad .Laot_word_name_955
  .quad aot_set_fw_6c63
.section .text
aot_get_fw_6c64:
  leaq reg_fw_6c64(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c64:
  leaq reg_fw_6c64(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_956:
  .byte 108
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_956:
  .quad .Laot_word_entry_955
  .quad .Laot_word_name_956
  .quad aot_get_fw_6c64
.section .rodata
.Laot_word_name_957:
  .byte 58
  .byte 108
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_957:
  .quad .Laot_word_entry_956
  .quad .Laot_word_name_957
  .quad aot_set_fw_6c64
.section .text
aot_get_fw_6c69:
  leaq reg_fw_6c69(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c69:
  leaq reg_fw_6c69(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_958:
  .byte 108
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_958:
  .quad .Laot_word_entry_957
  .quad .Laot_word_name_958
  .quad aot_get_fw_6c69
.section .rodata
.Laot_word_name_959:
  .byte 58
  .byte 108
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_959:
  .quad .Laot_word_entry_958
  .quad .Laot_word_name_959
  .quad aot_set_fw_6c69
.section .text
aot_get_fw_6c6b:
  leaq reg_fw_6c6b(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c6b:
  leaq reg_fw_6c6b(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_960:
  .byte 108
  .byte 107
  .byte 0
.section .data
.Laot_word_entry_960:
  .quad .Laot_word_entry_959
  .quad .Laot_word_name_960
  .quad aot_get_fw_6c6b
.section .rodata
.Laot_word_name_961:
  .byte 58
  .byte 108
  .byte 107
  .byte 0
.section .data
.Laot_word_entry_961:
  .quad .Laot_word_entry_960
  .quad .Laot_word_name_961
  .quad aot_set_fw_6c6b
.section .text
aot_get_fw_6c6e:
  leaq reg_fw_6c6e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c6e:
  leaq reg_fw_6c6e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_962:
  .byte 108
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_962:
  .quad .Laot_word_entry_961
  .quad .Laot_word_name_962
  .quad aot_get_fw_6c6e
.section .rodata
.Laot_word_name_963:
  .byte 58
  .byte 108
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_963:
  .quad .Laot_word_entry_962
  .quad .Laot_word_name_963
  .quad aot_set_fw_6c6e
.section .text
aot_get_fw_6c6e2d636f6c6f72:
  leaq reg_fw_6c6e2d636f6c6f72(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c6e2d636f6c6f72:
  leaq reg_fw_6c6e2d636f6c6f72(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_964:
  .byte 108
  .byte 110
  .byte 45
  .byte 99
  .byte 111
  .byte 108
  .byte 111
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_964:
  .quad .Laot_word_entry_963
  .quad .Laot_word_name_964
  .quad aot_get_fw_6c6e2d636f6c6f72
.section .rodata
.Laot_word_name_965:
  .byte 58
  .byte 108
  .byte 110
  .byte 45
  .byte 99
  .byte 111
  .byte 108
  .byte 111
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_965:
  .quad .Laot_word_entry_964
  .quad .Laot_word_name_965
  .quad aot_set_fw_6c6e2d636f6c6f72
.section .text
aot_get_fw_6c6e2d636f756e74:
  leaq reg_fw_6c6e2d636f756e74(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c6e2d636f756e74:
  leaq reg_fw_6c6e2d636f756e74(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_966:
  .byte 108
  .byte 110
  .byte 45
  .byte 99
  .byte 111
  .byte 117
  .byte 110
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_966:
  .quad .Laot_word_entry_965
  .quad .Laot_word_name_966
  .quad aot_get_fw_6c6e2d636f756e74
.section .rodata
.Laot_word_name_967:
  .byte 58
  .byte 108
  .byte 110
  .byte 45
  .byte 99
  .byte 111
  .byte 117
  .byte 110
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_967:
  .quad .Laot_word_entry_966
  .quad .Laot_word_name_967
  .quad aot_set_fw_6c6e2d636f756e74
.section .text
aot_get_fw_6c6e2d6478:
  leaq reg_fw_6c6e2d6478(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c6e2d6478:
  leaq reg_fw_6c6e2d6478(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_968:
  .byte 108
  .byte 110
  .byte 45
  .byte 100
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_968:
  .quad .Laot_word_entry_967
  .quad .Laot_word_name_968
  .quad aot_get_fw_6c6e2d6478
.section .rodata
.Laot_word_name_969:
  .byte 58
  .byte 108
  .byte 110
  .byte 45
  .byte 100
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_969:
  .quad .Laot_word_entry_968
  .quad .Laot_word_name_969
  .quad aot_set_fw_6c6e2d6478
.section .text
aot_get_fw_6c6e2d6479:
  leaq reg_fw_6c6e2d6479(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c6e2d6479:
  leaq reg_fw_6c6e2d6479(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_970:
  .byte 108
  .byte 110
  .byte 45
  .byte 100
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_970:
  .quad .Laot_word_entry_969
  .quad .Laot_word_name_970
  .quad aot_get_fw_6c6e2d6479
.section .rodata
.Laot_word_name_971:
  .byte 58
  .byte 108
  .byte 110
  .byte 45
  .byte 100
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_971:
  .quad .Laot_word_entry_970
  .quad .Laot_word_name_971
  .quad aot_set_fw_6c6e2d6479
.section .text
aot_get_fw_6c6e2d69:
  leaq reg_fw_6c6e2d69(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c6e2d69:
  leaq reg_fw_6c6e2d69(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_972:
  .byte 108
  .byte 110
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_972:
  .quad .Laot_word_entry_971
  .quad .Laot_word_name_972
  .quad aot_get_fw_6c6e2d69
.section .rodata
.Laot_word_name_973:
  .byte 58
  .byte 108
  .byte 110
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_973:
  .quad .Laot_word_entry_972
  .quad .Laot_word_name_973
  .quad aot_set_fw_6c6e2d69
.section .text
aot_get_fw_6c6e2d7830:
  leaq reg_fw_6c6e2d7830(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c6e2d7830:
  leaq reg_fw_6c6e2d7830(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_974:
  .byte 108
  .byte 110
  .byte 45
  .byte 120
  .byte 48
  .byte 0
.section .data
.Laot_word_entry_974:
  .quad .Laot_word_entry_973
  .quad .Laot_word_name_974
  .quad aot_get_fw_6c6e2d7830
.section .rodata
.Laot_word_name_975:
  .byte 58
  .byte 108
  .byte 110
  .byte 45
  .byte 120
  .byte 48
  .byte 0
.section .data
.Laot_word_entry_975:
  .quad .Laot_word_entry_974
  .quad .Laot_word_name_975
  .quad aot_set_fw_6c6e2d7830
.section .text
aot_get_fw_6c6e2d7831:
  leaq reg_fw_6c6e2d7831(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c6e2d7831:
  leaq reg_fw_6c6e2d7831(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_976:
  .byte 108
  .byte 110
  .byte 45
  .byte 120
  .byte 49
  .byte 0
.section .data
.Laot_word_entry_976:
  .quad .Laot_word_entry_975
  .quad .Laot_word_name_976
  .quad aot_get_fw_6c6e2d7831
.section .rodata
.Laot_word_name_977:
  .byte 58
  .byte 108
  .byte 110
  .byte 45
  .byte 120
  .byte 49
  .byte 0
.section .data
.Laot_word_entry_977:
  .quad .Laot_word_entry_976
  .quad .Laot_word_name_977
  .quad aot_set_fw_6c6e2d7831
.section .text
aot_get_fw_6c6e2d7930:
  leaq reg_fw_6c6e2d7930(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c6e2d7930:
  leaq reg_fw_6c6e2d7930(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_978:
  .byte 108
  .byte 110
  .byte 45
  .byte 121
  .byte 48
  .byte 0
.section .data
.Laot_word_entry_978:
  .quad .Laot_word_entry_977
  .quad .Laot_word_name_978
  .quad aot_get_fw_6c6e2d7930
.section .rodata
.Laot_word_name_979:
  .byte 58
  .byte 108
  .byte 110
  .byte 45
  .byte 121
  .byte 48
  .byte 0
.section .data
.Laot_word_entry_979:
  .quad .Laot_word_entry_978
  .quad .Laot_word_name_979
  .quad aot_set_fw_6c6e2d7930
.section .text
aot_get_fw_6c6e2d7931:
  leaq reg_fw_6c6e2d7931(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c6e2d7931:
  leaq reg_fw_6c6e2d7931(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_980:
  .byte 108
  .byte 110
  .byte 45
  .byte 121
  .byte 49
  .byte 0
.section .data
.Laot_word_entry_980:
  .quad .Laot_word_entry_979
  .quad .Laot_word_name_980
  .quad aot_get_fw_6c6e2d7931
.section .rodata
.Laot_word_name_981:
  .byte 58
  .byte 108
  .byte 110
  .byte 45
  .byte 121
  .byte 49
  .byte 0
.section .data
.Laot_word_entry_981:
  .quad .Laot_word_entry_980
  .quad .Laot_word_name_981
  .quad aot_set_fw_6c6e2d7931
.section .text
aot_get_fw_6c6f61642d64617461:
  leaq reg_fw_6c6f61642d64617461(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c6f61642d64617461:
  leaq reg_fw_6c6f61642d64617461(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_982:
  .byte 108
  .byte 111
  .byte 97
  .byte 100
  .byte 45
  .byte 100
  .byte 97
  .byte 116
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_982:
  .quad .Laot_word_entry_981
  .quad .Laot_word_name_982
  .quad aot_get_fw_6c6f61642d64617461
.section .rodata
.Laot_word_name_983:
  .byte 58
  .byte 108
  .byte 111
  .byte 97
  .byte 100
  .byte 45
  .byte 100
  .byte 97
  .byte 116
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_983:
  .quad .Laot_word_entry_982
  .quad .Laot_word_name_983
  .quad aot_set_fw_6c6f61642d64617461
.section .text
aot_get_fw_6c73:
  leaq reg_fw_6c73(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c73:
  leaq reg_fw_6c73(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_984:
  .byte 108
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_984:
  .quad .Laot_word_entry_983
  .quad .Laot_word_name_984
  .quad aot_get_fw_6c73
.section .rodata
.Laot_word_name_985:
  .byte 58
  .byte 108
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_985:
  .quad .Laot_word_entry_984
  .quad .Laot_word_name_985
  .quad aot_set_fw_6c73
.section .text
aot_get_fw_6c73756d:
  leaq reg_fw_6c73756d(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c73756d:
  leaq reg_fw_6c73756d(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_986:
  .byte 108
  .byte 115
  .byte 117
  .byte 109
  .byte 0
.section .data
.Laot_word_entry_986:
  .quad .Laot_word_entry_985
  .quad .Laot_word_name_986
  .quad aot_get_fw_6c73756d
.section .rodata
.Laot_word_name_987:
  .byte 58
  .byte 108
  .byte 115
  .byte 117
  .byte 109
  .byte 0
.section .data
.Laot_word_entry_987:
  .quad .Laot_word_entry_986
  .quad .Laot_word_name_987
  .quad aot_set_fw_6c73756d
.section .text
aot_get_fw_6c74:
  leaq reg_fw_6c74(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c74:
  leaq reg_fw_6c74(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_988:
  .byte 108
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_988:
  .quad .Laot_word_entry_987
  .quad .Laot_word_name_988
  .quad aot_get_fw_6c74
.section .rodata
.Laot_word_name_989:
  .byte 58
  .byte 108
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_989:
  .quad .Laot_word_entry_988
  .quad .Laot_word_name_989
  .quad aot_set_fw_6c74
.section .text
aot_get_fw_6c7465726d:
  leaq reg_fw_6c7465726d(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c7465726d:
  leaq reg_fw_6c7465726d(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_990:
  .byte 108
  .byte 116
  .byte 101
  .byte 114
  .byte 109
  .byte 0
.section .data
.Laot_word_entry_990:
  .quad .Laot_word_entry_989
  .quad .Laot_word_name_990
  .quad aot_get_fw_6c7465726d
.section .rodata
.Laot_word_name_991:
  .byte 58
  .byte 108
  .byte 116
  .byte 101
  .byte 114
  .byte 109
  .byte 0
.section .data
.Laot_word_entry_991:
  .quad .Laot_word_entry_990
  .quad .Laot_word_name_991
  .quad aot_set_fw_6c7465726d
.section .text
aot_get_fw_6c75:
  leaq reg_fw_6c75(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c75:
  leaq reg_fw_6c75(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_992:
  .byte 108
  .byte 117
  .byte 0
.section .data
.Laot_word_entry_992:
  .quad .Laot_word_entry_991
  .quad .Laot_word_name_992
  .quad aot_get_fw_6c75
.section .rodata
.Laot_word_name_993:
  .byte 58
  .byte 108
  .byte 117
  .byte 0
.section .data
.Laot_word_entry_993:
  .quad .Laot_word_entry_992
  .quad .Laot_word_name_993
  .quad aot_set_fw_6c75
.section .text
aot_get_fw_6c78:
  leaq reg_fw_6c78(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c78:
  leaq reg_fw_6c78(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_994:
  .byte 108
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_994:
  .quad .Laot_word_entry_993
  .quad .Laot_word_name_994
  .quad aot_get_fw_6c78
.section .rodata
.Laot_word_name_995:
  .byte 58
  .byte 108
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_995:
  .quad .Laot_word_entry_994
  .quad .Laot_word_name_995
  .quad aot_set_fw_6c78
.section .text
aot_get_fw_6c79:
  leaq reg_fw_6c79(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c79:
  leaq reg_fw_6c79(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_996:
  .byte 108
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_996:
  .quad .Laot_word_entry_995
  .quad .Laot_word_name_996
  .quad aot_get_fw_6c79
.section .rodata
.Laot_word_name_997:
  .byte 58
  .byte 108
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_997:
  .quad .Laot_word_entry_996
  .quad .Laot_word_name_997
  .quad aot_set_fw_6c79
.section .text
aot_get_fw_6d61:
  leaq reg_fw_6d61(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6d61:
  leaq reg_fw_6d61(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_998:
  .byte 109
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_998:
  .quad .Laot_word_entry_997
  .quad .Laot_word_name_998
  .quad aot_get_fw_6d61
.section .rodata
.Laot_word_name_999:
  .byte 58
  .byte 109
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_999:
  .quad .Laot_word_entry_998
  .quad .Laot_word_name_999
  .quad aot_set_fw_6d61
.section .text
aot_get_fw_6d62:
  leaq reg_fw_6d62(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6d62:
  leaq reg_fw_6d62(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1000:
  .byte 109
  .byte 98
  .byte 0
.section .data
.Laot_word_entry_1000:
  .quad .Laot_word_entry_999
  .quad .Laot_word_name_1000
  .quad aot_get_fw_6d62
.section .rodata
.Laot_word_name_1001:
  .byte 58
  .byte 109
  .byte 98
  .byte 0
.section .data
.Laot_word_entry_1001:
  .quad .Laot_word_entry_1000
  .quad .Laot_word_name_1001
  .quad aot_set_fw_6d62
.section .text
aot_get_fw_6d70:
  leaq reg_fw_6d70(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6d70:
  leaq reg_fw_6d70(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1002:
  .byte 109
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1002:
  .quad .Laot_word_entry_1001
  .quad .Laot_word_name_1002
  .quad aot_get_fw_6d70
.section .rodata
.Laot_word_name_1003:
  .byte 58
  .byte 109
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1003:
  .quad .Laot_word_entry_1002
  .quad .Laot_word_name_1003
  .quad aot_set_fw_6d70
.section .text
aot_get_fw_6d7a:
  leaq reg_fw_6d7a(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6d7a:
  leaq reg_fw_6d7a(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1004:
  .byte 109
  .byte 122
  .byte 0
.section .data
.Laot_word_entry_1004:
  .quad .Laot_word_entry_1003
  .quad .Laot_word_name_1004
  .quad aot_get_fw_6d7a
.section .rodata
.Laot_word_name_1005:
  .byte 58
  .byte 109
  .byte 122
  .byte 0
.section .data
.Laot_word_entry_1005:
  .quad .Laot_word_entry_1004
  .quad .Laot_word_name_1005
  .quad aot_set_fw_6d7a
.section .text
aot_get_fw_706970726563:
  leaq reg_fw_706970726563(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_706970726563:
  leaq reg_fw_706970726563(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1006:
  .byte 112
  .byte 105
  .byte 112
  .byte 114
  .byte 101
  .byte 99
  .byte 0
.section .data
.Laot_word_entry_1006:
  .quad .Laot_word_entry_1005
  .quad .Laot_word_name_1006
  .quad aot_get_fw_706970726563
.section .rodata
.Laot_word_name_1007:
  .byte 58
  .byte 112
  .byte 105
  .byte 112
  .byte 114
  .byte 101
  .byte 99
  .byte 0
.section .data
.Laot_word_entry_1007:
  .quad .Laot_word_entry_1006
  .quad .Laot_word_name_1007
  .quad aot_set_fw_706970726563
.section .text
aot_get_fw_706976616c:
  leaq reg_fw_706976616c(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_706976616c:
  leaq reg_fw_706976616c(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1008:
  .byte 112
  .byte 105
  .byte 118
  .byte 97
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_1008:
  .quad .Laot_word_entry_1007
  .quad .Laot_word_name_1008
  .quad aot_get_fw_706976616c
.section .rodata
.Laot_word_name_1009:
  .byte 58
  .byte 112
  .byte 105
  .byte 118
  .byte 97
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_1009:
  .quad .Laot_word_entry_1008
  .quad .Laot_word_name_1009
  .quad aot_set_fw_706976616c
.section .text
aot_get_fw_706c2d626c7565:
  leaq reg_fw_706c2d626c7565(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_706c2d626c7565:
  leaq reg_fw_706c2d626c7565(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1010:
  .byte 112
  .byte 108
  .byte 45
  .byte 98
  .byte 108
  .byte 117
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1010:
  .quad .Laot_word_entry_1009
  .quad .Laot_word_name_1010
  .quad aot_get_fw_706c2d626c7565
.section .rodata
.Laot_word_name_1011:
  .byte 58
  .byte 112
  .byte 108
  .byte 45
  .byte 98
  .byte 108
  .byte 117
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1011:
  .quad .Laot_word_entry_1010
  .quad .Laot_word_name_1011
  .quad aot_set_fw_706c2d626c7565
.section .text
aot_get_fw_706c2d677265656e:
  leaq reg_fw_706c2d677265656e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_706c2d677265656e:
  leaq reg_fw_706c2d677265656e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1012:
  .byte 112
  .byte 108
  .byte 45
  .byte 103
  .byte 114
  .byte 101
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_1012:
  .quad .Laot_word_entry_1011
  .quad .Laot_word_name_1012
  .quad aot_get_fw_706c2d677265656e
.section .rodata
.Laot_word_name_1013:
  .byte 58
  .byte 112
  .byte 108
  .byte 45
  .byte 103
  .byte 114
  .byte 101
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_1013:
  .quad .Laot_word_entry_1012
  .quad .Laot_word_name_1013
  .quad aot_set_fw_706c2d677265656e
.section .text
aot_get_fw_706c2d696e646578:
  leaq reg_fw_706c2d696e646578(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_706c2d696e646578:
  leaq reg_fw_706c2d696e646578(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1014:
  .byte 112
  .byte 108
  .byte 45
  .byte 105
  .byte 110
  .byte 100
  .byte 101
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_1014:
  .quad .Laot_word_entry_1013
  .quad .Laot_word_name_1014
  .quad aot_get_fw_706c2d696e646578
.section .rodata
.Laot_word_name_1015:
  .byte 58
  .byte 112
  .byte 108
  .byte 45
  .byte 105
  .byte 110
  .byte 100
  .byte 101
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_1015:
  .quad .Laot_word_entry_1014
  .quad .Laot_word_name_1015
  .quad aot_set_fw_706c2d696e646578
.section .text
aot_get_fw_706c2d726564:
  leaq reg_fw_706c2d726564(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_706c2d726564:
  leaq reg_fw_706c2d726564(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1016:
  .byte 112
  .byte 108
  .byte 45
  .byte 114
  .byte 101
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_1016:
  .quad .Laot_word_entry_1015
  .quad .Laot_word_name_1016
  .quad aot_get_fw_706c2d726564
.section .rodata
.Laot_word_name_1017:
  .byte 58
  .byte 112
  .byte 108
  .byte 45
  .byte 114
  .byte 101
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_1017:
  .quad .Laot_word_entry_1016
  .quad .Laot_word_name_1017
  .quad aot_set_fw_706c2d726564
.section .text
aot_get_fw_706f772d62617365:
  leaq reg_fw_706f772d62617365(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_706f772d62617365:
  leaq reg_fw_706f772d62617365(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1018:
  .byte 112
  .byte 111
  .byte 119
  .byte 45
  .byte 98
  .byte 97
  .byte 115
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1018:
  .quad .Laot_word_entry_1017
  .quad .Laot_word_name_1018
  .quad aot_get_fw_706f772d62617365
.section .rodata
.Laot_word_name_1019:
  .byte 58
  .byte 112
  .byte 111
  .byte 119
  .byte 45
  .byte 98
  .byte 97
  .byte 115
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1019:
  .quad .Laot_word_entry_1018
  .quad .Laot_word_name_1019
  .quad aot_set_fw_706f772d62617365
.section .text
aot_get_fw_706f772d6578706f6e656e74:
  leaq reg_fw_706f772d6578706f6e656e74(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_706f772d6578706f6e656e74:
  leaq reg_fw_706f772d6578706f6e656e74(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1020:
  .byte 112
  .byte 111
  .byte 119
  .byte 45
  .byte 101
  .byte 120
  .byte 112
  .byte 111
  .byte 110
  .byte 101
  .byte 110
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_1020:
  .quad .Laot_word_entry_1019
  .quad .Laot_word_name_1020
  .quad aot_get_fw_706f772d6578706f6e656e74
.section .rodata
.Laot_word_name_1021:
  .byte 58
  .byte 112
  .byte 111
  .byte 119
  .byte 45
  .byte 101
  .byte 120
  .byte 112
  .byte 111
  .byte 110
  .byte 101
  .byte 110
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_1021:
  .quad .Laot_word_entry_1020
  .quad .Laot_word_name_1021
  .quad aot_set_fw_706f772d6578706f6e656e74
.section .text
aot_get_fw_706f772d726573756c74:
  leaq reg_fw_706f772d726573756c74(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_706f772d726573756c74:
  leaq reg_fw_706f772d726573756c74(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1022:
  .byte 112
  .byte 111
  .byte 119
  .byte 45
  .byte 114
  .byte 101
  .byte 115
  .byte 117
  .byte 108
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_1022:
  .quad .Laot_word_entry_1021
  .quad .Laot_word_name_1022
  .quad aot_get_fw_706f772d726573756c74
.section .rodata
.Laot_word_name_1023:
  .byte 58
  .byte 112
  .byte 111
  .byte 119
  .byte 45
  .byte 114
  .byte 101
  .byte 115
  .byte 117
  .byte 108
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_1023:
  .quad .Laot_word_entry_1022
  .quad .Laot_word_name_1023
  .quad aot_set_fw_706f772d726573756c74
.section .text
aot_get_fw_70782d78:
  leaq reg_fw_70782d78(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_70782d78:
  leaq reg_fw_70782d78(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1024:
  .byte 112
  .byte 120
  .byte 45
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_1024:
  .quad .Laot_word_entry_1023
  .quad .Laot_word_name_1024
  .quad aot_get_fw_70782d78
.section .rodata
.Laot_word_name_1025:
  .byte 58
  .byte 112
  .byte 120
  .byte 45
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_1025:
  .quad .Laot_word_entry_1024
  .quad .Laot_word_name_1025
  .quad aot_set_fw_70782d78
.section .text
aot_get_fw_70782d79:
  leaq reg_fw_70782d79(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_70782d79:
  leaq reg_fw_70782d79(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1026:
  .byte 112
  .byte 120
  .byte 45
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_1026:
  .quad .Laot_word_entry_1025
  .quad .Laot_word_name_1026
  .quad aot_get_fw_70782d79
.section .rodata
.Laot_word_name_1027:
  .byte 58
  .byte 112
  .byte 120
  .byte 45
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_1027:
  .quad .Laot_word_entry_1026
  .quad .Laot_word_name_1027
  .quad aot_set_fw_70782d79
.section .text
aot_get_fw_7264:
  leaq reg_fw_7264(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7264:
  leaq reg_fw_7264(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1028:
  .byte 114
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_1028:
  .quad .Laot_word_entry_1027
  .quad .Laot_word_name_1028
  .quad aot_get_fw_7264
.section .rodata
.Laot_word_name_1029:
  .byte 58
  .byte 114
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_1029:
  .quad .Laot_word_entry_1028
  .quad .Laot_word_name_1029
  .quad aot_set_fw_7264
.section .text
aot_get_fw_726e:
  leaq reg_fw_726e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_726e:
  leaq reg_fw_726e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1030:
  .byte 114
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_1030:
  .quad .Laot_word_entry_1029
  .quad .Laot_word_name_1030
  .quad aot_get_fw_726e
.section .rodata
.Laot_word_name_1031:
  .byte 58
  .byte 114
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_1031:
  .quad .Laot_word_entry_1030
  .quad .Laot_word_name_1031
  .quad aot_set_fw_726e
.section .text
aot_get_fw_7278:
  leaq reg_fw_7278(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7278:
  leaq reg_fw_7278(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1032:
  .byte 114
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_1032:
  .quad .Laot_word_entry_1031
  .quad .Laot_word_name_1032
  .quad aot_get_fw_7278
.section .rodata
.Laot_word_name_1033:
  .byte 58
  .byte 114
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_1033:
  .quad .Laot_word_entry_1032
  .quad .Laot_word_name_1033
  .quad aot_set_fw_7278
.section .text
aot_get_fw_7365:
  leaq reg_fw_7365(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7365:
  leaq reg_fw_7365(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1034:
  .byte 115
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1034:
  .quad .Laot_word_entry_1033
  .quad .Laot_word_name_1034
  .quad aot_get_fw_7365
.section .rodata
.Laot_word_name_1035:
  .byte 58
  .byte 115
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1035:
  .quad .Laot_word_entry_1034
  .quad .Laot_word_name_1035
  .quad aot_set_fw_7365
.section .text
aot_get_fw_7367:
  leaq reg_fw_7367(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7367:
  leaq reg_fw_7367(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1036:
  .byte 115
  .byte 103
  .byte 0
.section .data
.Laot_word_entry_1036:
  .quad .Laot_word_entry_1035
  .quad .Laot_word_name_1036
  .quad aot_get_fw_7367
.section .rodata
.Laot_word_name_1037:
  .byte 58
  .byte 115
  .byte 103
  .byte 0
.section .data
.Laot_word_entry_1037:
  .quad .Laot_word_entry_1036
  .quad .Laot_word_name_1037
  .quad aot_set_fw_7367
.section .text
aot_get_fw_7368:
  leaq reg_fw_7368(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7368:
  leaq reg_fw_7368(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1038:
  .byte 115
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_1038:
  .quad .Laot_word_entry_1037
  .quad .Laot_word_name_1038
  .quad aot_get_fw_7368
.section .rodata
.Laot_word_name_1039:
  .byte 58
  .byte 115
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_1039:
  .quad .Laot_word_entry_1038
  .quad .Laot_word_name_1039
  .quad aot_set_fw_7368
.section .text
aot_get_fw_7369:
  leaq reg_fw_7369(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7369:
  leaq reg_fw_7369(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1040:
  .byte 115
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_1040:
  .quad .Laot_word_entry_1039
  .quad .Laot_word_name_1040
  .quad aot_get_fw_7369
.section .rodata
.Laot_word_name_1041:
  .byte 58
  .byte 115
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_1041:
  .quad .Laot_word_entry_1040
  .quad .Laot_word_name_1041
  .quad aot_set_fw_7369
.section .text
aot_get_fw_736e:
  leaq reg_fw_736e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_736e:
  leaq reg_fw_736e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1042:
  .byte 115
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_1042:
  .quad .Laot_word_entry_1041
  .quad .Laot_word_name_1042
  .quad aot_get_fw_736e
.section .rodata
.Laot_word_name_1043:
  .byte 58
  .byte 115
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_1043:
  .quad .Laot_word_entry_1042
  .quad .Laot_word_name_1043
  .quad aot_set_fw_736e
.section .text
aot_get_fw_7370:
  leaq reg_fw_7370(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7370:
  leaq reg_fw_7370(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1044:
  .byte 115
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1044:
  .quad .Laot_word_entry_1043
  .quad .Laot_word_name_1044
  .quad aot_get_fw_7370
.section .rodata
.Laot_word_name_1045:
  .byte 58
  .byte 115
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1045:
  .quad .Laot_word_entry_1044
  .quad .Laot_word_name_1045
  .quad aot_set_fw_7370
.section .text
aot_get_fw_737061:
  leaq reg_fw_737061(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_737061:
  leaq reg_fw_737061(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1046:
  .byte 115
  .byte 112
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_1046:
  .quad .Laot_word_entry_1045
  .quad .Laot_word_name_1046
  .quad aot_get_fw_737061
.section .rodata
.Laot_word_name_1047:
  .byte 58
  .byte 115
  .byte 112
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_1047:
  .quad .Laot_word_entry_1046
  .quad .Laot_word_name_1047
  .quad aot_set_fw_737061
.section .text
aot_get_fw_7370636f6c:
  leaq reg_fw_7370636f6c(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7370636f6c:
  leaq reg_fw_7370636f6c(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1048:
  .byte 115
  .byte 112
  .byte 99
  .byte 111
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_1048:
  .quad .Laot_word_entry_1047
  .quad .Laot_word_name_1048
  .quad aot_get_fw_7370636f6c
.section .rodata
.Laot_word_name_1049:
  .byte 58
  .byte 115
  .byte 112
  .byte 99
  .byte 111
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_1049:
  .quad .Laot_word_entry_1048
  .quad .Laot_word_name_1049
  .quad aot_set_fw_7370636f6c
.section .text
aot_get_fw_737069:
  leaq reg_fw_737069(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_737069:
  leaq reg_fw_737069(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1050:
  .byte 115
  .byte 112
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_1050:
  .quad .Laot_word_entry_1049
  .quad .Laot_word_name_1050
  .quad aot_get_fw_737069
.section .rodata
.Laot_word_name_1051:
  .byte 58
  .byte 115
  .byte 112
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_1051:
  .quad .Laot_word_entry_1050
  .quad .Laot_word_name_1051
  .quad aot_set_fw_737069
.section .text
aot_get_fw_73706d78:
  leaq reg_fw_73706d78(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73706d78:
  leaq reg_fw_73706d78(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1052:
  .byte 115
  .byte 112
  .byte 109
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_1052:
  .quad .Laot_word_entry_1051
  .quad .Laot_word_name_1052
  .quad aot_get_fw_73706d78
.section .rodata
.Laot_word_name_1053:
  .byte 58
  .byte 115
  .byte 112
  .byte 109
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_1053:
  .quad .Laot_word_entry_1052
  .quad .Laot_word_name_1053
  .quad aot_set_fw_73706d78
.section .text
aot_get_fw_73706e:
  leaq reg_fw_73706e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73706e:
  leaq reg_fw_73706e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1054:
  .byte 115
  .byte 112
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_1054:
  .quad .Laot_word_entry_1053
  .quad .Laot_word_name_1054
  .quad aot_get_fw_73706e
.section .rodata
.Laot_word_name_1055:
  .byte 58
  .byte 115
  .byte 112
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_1055:
  .quad .Laot_word_entry_1054
  .quad .Laot_word_name_1055
  .quad aot_set_fw_73706e
.section .text
aot_get_fw_737070:
  leaq reg_fw_737070(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_737070:
  leaq reg_fw_737070(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1056:
  .byte 115
  .byte 112
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1056:
  .quad .Laot_word_entry_1055
  .quad .Laot_word_name_1056
  .quad aot_get_fw_737070
.section .rodata
.Laot_word_name_1057:
  .byte 58
  .byte 115
  .byte 112
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1057:
  .quad .Laot_word_entry_1056
  .quad .Laot_word_name_1057
  .quad aot_set_fw_737070
.section .text
aot_get_fw_737071:
  leaq reg_fw_737071(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_737071:
  leaq reg_fw_737071(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1058:
  .byte 115
  .byte 112
  .byte 113
  .byte 0
.section .data
.Laot_word_entry_1058:
  .quad .Laot_word_entry_1057
  .quad .Laot_word_name_1058
  .quad aot_get_fw_737071
.section .rodata
.Laot_word_name_1059:
  .byte 58
  .byte 115
  .byte 112
  .byte 113
  .byte 0
.section .data
.Laot_word_entry_1059:
  .quad .Laot_word_entry_1058
  .quad .Laot_word_name_1059
  .quad aot_set_fw_737071
.section .text
aot_get_fw_73707363:
  leaq reg_fw_73707363(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73707363:
  leaq reg_fw_73707363(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1060:
  .byte 115
  .byte 112
  .byte 115
  .byte 99
  .byte 0
.section .data
.Laot_word_entry_1060:
  .quad .Laot_word_entry_1059
  .quad .Laot_word_name_1060
  .quad aot_get_fw_73707363
.section .rodata
.Laot_word_name_1061:
  .byte 58
  .byte 115
  .byte 112
  .byte 115
  .byte 99
  .byte 0
.section .data
.Laot_word_entry_1061:
  .quad .Laot_word_entry_1060
  .quad .Laot_word_name_1061
  .quad aot_set_fw_73707363
.section .text
aot_get_fw_737074:
  leaq reg_fw_737074(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_737074:
  leaq reg_fw_737074(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1062:
  .byte 115
  .byte 112
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_1062:
  .quad .Laot_word_entry_1061
  .quad .Laot_word_name_1062
  .quad aot_get_fw_737074
.section .rodata
.Laot_word_name_1063:
  .byte 58
  .byte 115
  .byte 112
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_1063:
  .quad .Laot_word_entry_1062
  .quad .Laot_word_name_1063
  .quad aot_set_fw_737074
.section .text
aot_get_fw_737078:
  leaq reg_fw_737078(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_737078:
  leaq reg_fw_737078(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1064:
  .byte 115
  .byte 112
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_1064:
  .quad .Laot_word_entry_1063
  .quad .Laot_word_name_1064
  .quad aot_get_fw_737078
.section .rodata
.Laot_word_name_1065:
  .byte 58
  .byte 115
  .byte 112
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_1065:
  .quad .Laot_word_entry_1064
  .quad .Laot_word_name_1065
  .quad aot_set_fw_737078
.section .text
aot_get_fw_73707878:
  leaq reg_fw_73707878(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73707878:
  leaq reg_fw_73707878(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1066:
  .byte 115
  .byte 112
  .byte 120
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_1066:
  .quad .Laot_word_entry_1065
  .quad .Laot_word_name_1066
  .quad aot_get_fw_73707878
.section .rodata
.Laot_word_name_1067:
  .byte 58
  .byte 115
  .byte 112
  .byte 120
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_1067:
  .quad .Laot_word_entry_1066
  .quad .Laot_word_name_1067
  .quad aot_set_fw_73707878
.section .text
aot_get_fw_737079:
  leaq reg_fw_737079(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_737079:
  leaq reg_fw_737079(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1068:
  .byte 115
  .byte 112
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_1068:
  .quad .Laot_word_entry_1067
  .quad .Laot_word_name_1068
  .quad aot_get_fw_737079
.section .rodata
.Laot_word_name_1069:
  .byte 58
  .byte 115
  .byte 112
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_1069:
  .quad .Laot_word_entry_1068
  .quad .Laot_word_name_1069
  .quad aot_set_fw_737079
.section .text
aot_get_fw_73707979:
  leaq reg_fw_73707979(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73707979:
  leaq reg_fw_73707979(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1070:
  .byte 115
  .byte 112
  .byte 121
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_1070:
  .quad .Laot_word_entry_1069
  .quad .Laot_word_name_1070
  .quad aot_get_fw_73707979
.section .rodata
.Laot_word_name_1071:
  .byte 58
  .byte 115
  .byte 112
  .byte 121
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_1071:
  .quad .Laot_word_entry_1070
  .quad .Laot_word_name_1071
  .quad aot_set_fw_73707979
.section .text
aot_get_fw_7373:
  leaq reg_fw_7373(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7373:
  leaq reg_fw_7373(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1072:
  .byte 115
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_1072:
  .quad .Laot_word_entry_1071
  .quad .Laot_word_name_1072
  .quad aot_get_fw_7373
.section .rodata
.Laot_word_name_1073:
  .byte 58
  .byte 115
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_1073:
  .quad .Laot_word_entry_1072
  .quad .Laot_word_name_1073
  .quad aot_set_fw_7373
.section .text
aot_get_fw_7374:
  leaq reg_fw_7374(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7374:
  leaq reg_fw_7374(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1074:
  .byte 115
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_1074:
  .quad .Laot_word_entry_1073
  .quad .Laot_word_name_1074
  .quad aot_get_fw_7374
.section .rodata
.Laot_word_name_1075:
  .byte 58
  .byte 115
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_1075:
  .quad .Laot_word_entry_1074
  .quad .Laot_word_name_1075
  .quad aot_set_fw_7374
.section .text
aot_get_fw_7378:
  leaq reg_fw_7378(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7378:
  leaq reg_fw_7378(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1076:
  .byte 115
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_1076:
  .quad .Laot_word_entry_1075
  .quad .Laot_word_name_1076
  .quad aot_get_fw_7378
.section .rodata
.Laot_word_name_1077:
  .byte 58
  .byte 115
  .byte 120
  .byte 0
.section .data
.Laot_word_entry_1077:
  .quad .Laot_word_entry_1076
  .quad .Laot_word_name_1077
  .quad aot_set_fw_7378
.section .text
aot_get_fw_7379:
  leaq reg_fw_7379(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7379:
  leaq reg_fw_7379(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1078:
  .byte 115
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_1078:
  .quad .Laot_word_entry_1077
  .quad .Laot_word_name_1078
  .quad aot_get_fw_7379
.section .rodata
.Laot_word_name_1079:
  .byte 58
  .byte 115
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_1079:
  .quad .Laot_word_entry_1078
  .quad .Laot_word_name_1079
  .quad aot_set_fw_7379
.section .text
aot_get_fw_747031:
  leaq reg_fw_747031(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_747031:
  leaq reg_fw_747031(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1080:
  .byte 116
  .byte 112
  .byte 49
  .byte 0
.section .data
.Laot_word_entry_1080:
  .quad .Laot_word_entry_1079
  .quad .Laot_word_name_1080
  .quad aot_get_fw_747031
.section .rodata
.Laot_word_name_1081:
  .byte 58
  .byte 116
  .byte 112
  .byte 49
  .byte 0
.section .data
.Laot_word_entry_1081:
  .quad .Laot_word_entry_1080
  .quad .Laot_word_name_1081
  .quad aot_set_fw_747031
.section .text
aot_get_fw_747032:
  leaq reg_fw_747032(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_747032:
  leaq reg_fw_747032(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1082:
  .byte 116
  .byte 112
  .byte 50
  .byte 0
.section .data
.Laot_word_entry_1082:
  .quad .Laot_word_entry_1081
  .quad .Laot_word_name_1082
  .quad aot_get_fw_747032
.section .rodata
.Laot_word_name_1083:
  .byte 58
  .byte 116
  .byte 112
  .byte 50
  .byte 0
.section .data
.Laot_word_entry_1083:
  .quad .Laot_word_entry_1082
  .quad .Laot_word_name_1083
  .quad aot_set_fw_747032
.section .text
aot_get_fw_747131:
  leaq reg_fw_747131(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_747131:
  leaq reg_fw_747131(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1084:
  .byte 116
  .byte 113
  .byte 49
  .byte 0
.section .data
.Laot_word_entry_1084:
  .quad .Laot_word_entry_1083
  .quad .Laot_word_name_1084
  .quad aot_get_fw_747131
.section .rodata
.Laot_word_name_1085:
  .byte 58
  .byte 116
  .byte 113
  .byte 49
  .byte 0
.section .data
.Laot_word_entry_1085:
  .quad .Laot_word_entry_1084
  .quad .Laot_word_name_1085
  .quad aot_set_fw_747131
.section .text
aot_get_fw_747132:
  leaq reg_fw_747132(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_747132:
  leaq reg_fw_747132(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1086:
  .byte 116
  .byte 113
  .byte 50
  .byte 0
.section .data
.Laot_word_entry_1086:
  .quad .Laot_word_entry_1085
  .quad .Laot_word_name_1086
  .quad aot_get_fw_747132
.section .rodata
.Laot_word_name_1087:
  .byte 58
  .byte 116
  .byte 113
  .byte 50
  .byte 0
.section .data
.Laot_word_entry_1087:
  .quad .Laot_word_entry_1086
  .quad .Laot_word_name_1087
  .quad aot_set_fw_747132
.section .text
aot_get_fw_776b2d6b6579:
  leaq reg_fw_776b2d6b6579(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_776b2d6b6579:
  leaq reg_fw_776b2d6b6579(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1088:
  .byte 119
  .byte 107
  .byte 45
  .byte 107
  .byte 101
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_1088:
  .quad .Laot_word_entry_1087
  .quad .Laot_word_name_1088
  .quad aot_get_fw_776b2d6b6579
.section .rodata
.Laot_word_name_1089:
  .byte 58
  .byte 119
  .byte 107
  .byte 45
  .byte 107
  .byte 101
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_1089:
  .quad .Laot_word_entry_1088
  .quad .Laot_word_name_1089
  .quad aot_set_fw_776b2d6b6579
.section .text
aot_get_fw_776b2d6c:
  leaq reg_fw_776b2d6c(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_776b2d6c:
  leaq reg_fw_776b2d6c(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1090:
  .byte 119
  .byte 107
  .byte 45
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_1090:
  .quad .Laot_word_entry_1089
  .quad .Laot_word_name_1090
  .quad aot_get_fw_776b2d6c
.section .rodata
.Laot_word_name_1091:
  .byte 58
  .byte 119
  .byte 107
  .byte 45
  .byte 108
  .byte 0
.section .data
.Laot_word_entry_1091:
  .quad .Laot_word_entry_1090
  .quad .Laot_word_name_1091
  .quad aot_set_fw_776b2d6c
.section .text
aot_get_fw_776b2d6d:
  leaq reg_fw_776b2d6d(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_776b2d6d:
  leaq reg_fw_776b2d6d(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1092:
  .byte 119
  .byte 107
  .byte 45
  .byte 109
  .byte 0
.section .data
.Laot_word_entry_1092:
  .quad .Laot_word_entry_1091
  .quad .Laot_word_name_1092
  .quad aot_get_fw_776b2d6d
.section .rodata
.Laot_word_name_1093:
  .byte 58
  .byte 119
  .byte 107
  .byte 45
  .byte 109
  .byte 0
.section .data
.Laot_word_entry_1093:
  .quad .Laot_word_entry_1092
  .quad .Laot_word_name_1093
  .quad aot_set_fw_776b2d6d
.section .text
aot_get_fw_776b2d6e65787470:
  leaq reg_fw_776b2d6e65787470(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_776b2d6e65787470:
  leaq reg_fw_776b2d6e65787470(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1094:
  .byte 119
  .byte 107
  .byte 45
  .byte 110
  .byte 101
  .byte 120
  .byte 116
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1094:
  .quad .Laot_word_entry_1093
  .quad .Laot_word_name_1094
  .quad aot_get_fw_776b2d6e65787470
.section .rodata
.Laot_word_name_1095:
  .byte 58
  .byte 119
  .byte 107
  .byte 45
  .byte 110
  .byte 101
  .byte 120
  .byte 116
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1095:
  .quad .Laot_word_entry_1094
  .quad .Laot_word_name_1095
  .quad aot_set_fw_776b2d6e65787470
.section .text
aot_get_fw_776b2d6e65787471:
  leaq reg_fw_776b2d6e65787471(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_776b2d6e65787471:
  leaq reg_fw_776b2d6e65787471(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1096:
  .byte 119
  .byte 107
  .byte 45
  .byte 110
  .byte 101
  .byte 120
  .byte 116
  .byte 113
  .byte 0
.section .data
.Laot_word_entry_1096:
  .quad .Laot_word_entry_1095
  .quad .Laot_word_name_1096
  .quad aot_get_fw_776b2d6e65787471
.section .rodata
.Laot_word_name_1097:
  .byte 58
  .byte 119
  .byte 107
  .byte 45
  .byte 110
  .byte 101
  .byte 120
  .byte 116
  .byte 113
  .byte 0
.section .data
.Laot_word_entry_1097:
  .quad .Laot_word_entry_1096
  .quad .Laot_word_name_1097
  .quad aot_set_fw_776b2d6e65787471
.section .text
aot_get_fw_776b2d70:
  leaq reg_fw_776b2d70(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_776b2d70:
  leaq reg_fw_776b2d70(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1098:
  .byte 119
  .byte 107
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1098:
  .quad .Laot_word_entry_1097
  .quad .Laot_word_name_1098
  .quad aot_get_fw_776b2d70
.section .rodata
.Laot_word_name_1099:
  .byte 58
  .byte 119
  .byte 107
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1099:
  .quad .Laot_word_entry_1098
  .quad .Laot_word_name_1099
  .quad aot_set_fw_776b2d70
.section .text
aot_get_fw_776b2d71:
  leaq reg_fw_776b2d71(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_776b2d71:
  leaq reg_fw_776b2d71(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1100:
  .byte 119
  .byte 107
  .byte 45
  .byte 113
  .byte 0
.section .data
.Laot_word_entry_1100:
  .quad .Laot_word_entry_1099
  .quad .Laot_word_name_1100
  .quad aot_get_fw_776b2d71
.section .rodata
.Laot_word_name_1101:
  .byte 58
  .byte 119
  .byte 107
  .byte 45
  .byte 113
  .byte 0
.section .data
.Laot_word_entry_1101:
  .quad .Laot_word_entry_1100
  .quad .Laot_word_name_1101
  .quad aot_set_fw_776b2d71
.section .text
aot_get_fw_776b2d7374657073:
  leaq reg_fw_776b2d7374657073(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_776b2d7374657073:
  leaq reg_fw_776b2d7374657073(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1102:
  .byte 119
  .byte 107
  .byte 45
  .byte 115
  .byte 116
  .byte 101
  .byte 112
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_1102:
  .quad .Laot_word_entry_1101
  .quad .Laot_word_name_1102
  .quad aot_get_fw_776b2d7374657073
.section .rodata
.Laot_word_name_1103:
  .byte 58
  .byte 119
  .byte 107
  .byte 45
  .byte 115
  .byte 116
  .byte 101
  .byte 112
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_1103:
  .quad .Laot_word_entry_1102
  .quad .Laot_word_name_1103
  .quad aot_set_fw_776b2d7374657073
.section .text
aot_get_fw_776b2d75:
  leaq reg_fw_776b2d75(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_776b2d75:
  leaq reg_fw_776b2d75(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1104:
  .byte 119
  .byte 107
  .byte 45
  .byte 117
  .byte 0
.section .data
.Laot_word_entry_1104:
  .quad .Laot_word_entry_1103
  .quad .Laot_word_name_1104
  .quad aot_get_fw_776b2d75
.section .rodata
.Laot_word_name_1105:
  .byte 58
  .byte 119
  .byte 107
  .byte 45
  .byte 117
  .byte 0
.section .data
.Laot_word_entry_1105:
  .quad .Laot_word_entry_1104
  .quad .Laot_word_name_1105
  .quad aot_set_fw_776b2d75
.section .text
aot_get_fw_776b2d76:
  leaq reg_fw_776b2d76(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_776b2d76:
  leaq reg_fw_776b2d76(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1106:
  .byte 119
  .byte 107
  .byte 45
  .byte 118
  .byte 0
.section .data
.Laot_word_entry_1106:
  .quad .Laot_word_entry_1105
  .quad .Laot_word_name_1106
  .quad aot_get_fw_776b2d76
.section .rodata
.Laot_word_name_1107:
  .byte 58
  .byte 119
  .byte 107
  .byte 45
  .byte 118
  .byte 0
.section .data
.Laot_word_entry_1107:
  .quad .Laot_word_entry_1106
  .quad .Laot_word_name_1107
  .quad aot_set_fw_776b2d76
.section .text
aot_get_fw_626164642d61:
  leaq reg_fw_626164642d61(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_626164642d61:
  leaq reg_fw_626164642d61(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1108:
  .byte 98
  .byte 97
  .byte 100
  .byte 100
  .byte 45
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_1108:
  .quad .Laot_word_entry_1107
  .quad .Laot_word_name_1108
  .quad aot_get_fw_626164642d61
.section .rodata
.Laot_word_name_1109:
  .byte 58
  .byte 98
  .byte 97
  .byte 100
  .byte 100
  .byte 45
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_1109:
  .quad .Laot_word_entry_1108
  .quad .Laot_word_name_1109
  .quad aot_set_fw_626164642d61
.section .text
aot_get_fw_626164642d62:
  leaq reg_fw_626164642d62(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_626164642d62:
  leaq reg_fw_626164642d62(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1110:
  .byte 98
  .byte 97
  .byte 100
  .byte 100
  .byte 45
  .byte 98
  .byte 0
.section .data
.Laot_word_entry_1110:
  .quad .Laot_word_entry_1109
  .quad .Laot_word_name_1110
  .quad aot_get_fw_626164642d62
.section .rodata
.Laot_word_name_1111:
  .byte 58
  .byte 98
  .byte 97
  .byte 100
  .byte 100
  .byte 45
  .byte 98
  .byte 0
.section .data
.Laot_word_entry_1111:
  .quad .Laot_word_entry_1110
  .quad .Laot_word_name_1111
  .quad aot_set_fw_626164642d62
.section .text
aot_get_fw_626164642d6361727279:
  leaq reg_fw_626164642d6361727279(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_626164642d6361727279:
  leaq reg_fw_626164642d6361727279(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1112:
  .byte 98
  .byte 97
  .byte 100
  .byte 100
  .byte 45
  .byte 99
  .byte 97
  .byte 114
  .byte 114
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_1112:
  .quad .Laot_word_entry_1111
  .quad .Laot_word_name_1112
  .quad aot_get_fw_626164642d6361727279
.section .rodata
.Laot_word_name_1113:
  .byte 58
  .byte 98
  .byte 97
  .byte 100
  .byte 100
  .byte 45
  .byte 99
  .byte 97
  .byte 114
  .byte 114
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_1113:
  .quad .Laot_word_entry_1112
  .quad .Laot_word_name_1113
  .quad aot_set_fw_626164642d6361727279
.section .text
aot_get_fw_626164642d69:
  leaq reg_fw_626164642d69(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_626164642d69:
  leaq reg_fw_626164642d69(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1114:
  .byte 98
  .byte 97
  .byte 100
  .byte 100
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_1114:
  .quad .Laot_word_entry_1113
  .quad .Laot_word_name_1114
  .quad aot_get_fw_626164642d69
.section .rodata
.Laot_word_name_1115:
  .byte 58
  .byte 98
  .byte 97
  .byte 100
  .byte 100
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_1115:
  .quad .Laot_word_entry_1114
  .quad .Laot_word_name_1115
  .quad aot_set_fw_626164642d69
.section .text
aot_get_fw_626164642d6e:
  leaq reg_fw_626164642d6e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_626164642d6e:
  leaq reg_fw_626164642d6e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1116:
  .byte 98
  .byte 97
  .byte 100
  .byte 100
  .byte 45
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_1116:
  .quad .Laot_word_entry_1115
  .quad .Laot_word_name_1116
  .quad aot_get_fw_626164642d6e
.section .rodata
.Laot_word_name_1117:
  .byte 58
  .byte 98
  .byte 97
  .byte 100
  .byte 100
  .byte 45
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_1117:
  .quad .Laot_word_entry_1116
  .quad .Laot_word_name_1117
  .quad aot_set_fw_626164642d6e
.section .text
aot_get_fw_626164642d72:
  leaq reg_fw_626164642d72(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_626164642d72:
  leaq reg_fw_626164642d72(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1118:
  .byte 98
  .byte 97
  .byte 100
  .byte 100
  .byte 45
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_1118:
  .quad .Laot_word_entry_1117
  .quad .Laot_word_name_1118
  .quad aot_get_fw_626164642d72
.section .rodata
.Laot_word_name_1119:
  .byte 58
  .byte 98
  .byte 97
  .byte 100
  .byte 100
  .byte 45
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_1119:
  .quad .Laot_word_entry_1118
  .quad .Laot_word_name_1119
  .quad aot_set_fw_626164642d72
.section .text
aot_get_fw_626164642d73:
  leaq reg_fw_626164642d73(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_626164642d73:
  leaq reg_fw_626164642d73(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1120:
  .byte 98
  .byte 97
  .byte 100
  .byte 100
  .byte 45
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_1120:
  .quad .Laot_word_entry_1119
  .quad .Laot_word_name_1120
  .quad aot_get_fw_626164642d73
.section .rodata
.Laot_word_name_1121:
  .byte 58
  .byte 98
  .byte 97
  .byte 100
  .byte 100
  .byte 45
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_1121:
  .quad .Laot_word_entry_1120
  .quad .Laot_word_name_1121
  .quad aot_set_fw_626164642d73
.section .text
aot_get_fw_626361702d70:
  leaq reg_fw_626361702d70(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_626361702d70:
  leaq reg_fw_626361702d70(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1122:
  .byte 98
  .byte 99
  .byte 97
  .byte 112
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1122:
  .quad .Laot_word_entry_1121
  .quad .Laot_word_name_1122
  .quad aot_get_fw_626361702d70
.section .rodata
.Laot_word_name_1123:
  .byte 58
  .byte 98
  .byte 99
  .byte 97
  .byte 112
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1123:
  .quad .Laot_word_entry_1122
  .quad .Laot_word_name_1123
  .quad aot_set_fw_626361702d70
.section .text
aot_get_fw_62636d702d61:
  leaq reg_fw_62636d702d61(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_62636d702d61:
  leaq reg_fw_62636d702d61(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1124:
  .byte 98
  .byte 99
  .byte 109
  .byte 112
  .byte 45
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_1124:
  .quad .Laot_word_entry_1123
  .quad .Laot_word_name_1124
  .quad aot_get_fw_62636d702d61
.section .rodata
.Laot_word_name_1125:
  .byte 58
  .byte 98
  .byte 99
  .byte 109
  .byte 112
  .byte 45
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_1125:
  .quad .Laot_word_entry_1124
  .quad .Laot_word_name_1125
  .quad aot_set_fw_62636d702d61
.section .text
aot_get_fw_62636d702d62:
  leaq reg_fw_62636d702d62(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_62636d702d62:
  leaq reg_fw_62636d702d62(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1126:
  .byte 98
  .byte 99
  .byte 109
  .byte 112
  .byte 45
  .byte 98
  .byte 0
.section .data
.Laot_word_entry_1126:
  .quad .Laot_word_entry_1125
  .quad .Laot_word_name_1126
  .quad aot_get_fw_62636d702d62
.section .rodata
.Laot_word_name_1127:
  .byte 58
  .byte 98
  .byte 99
  .byte 109
  .byte 112
  .byte 45
  .byte 98
  .byte 0
.section .data
.Laot_word_entry_1127:
  .quad .Laot_word_entry_1126
  .quad .Laot_word_name_1127
  .quad aot_set_fw_62636d702d62
.section .text
aot_get_fw_62636d702d64:
  leaq reg_fw_62636d702d64(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_62636d702d64:
  leaq reg_fw_62636d702d64(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1128:
  .byte 98
  .byte 99
  .byte 109
  .byte 112
  .byte 45
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_1128:
  .quad .Laot_word_entry_1127
  .quad .Laot_word_name_1128
  .quad aot_get_fw_62636d702d64
.section .rodata
.Laot_word_name_1129:
  .byte 58
  .byte 98
  .byte 99
  .byte 109
  .byte 112
  .byte 45
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_1129:
  .quad .Laot_word_entry_1128
  .quad .Laot_word_name_1129
  .quad aot_set_fw_62636d702d64
.section .text
aot_get_fw_62636d702d69:
  leaq reg_fw_62636d702d69(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_62636d702d69:
  leaq reg_fw_62636d702d69(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1130:
  .byte 98
  .byte 99
  .byte 109
  .byte 112
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_1130:
  .quad .Laot_word_entry_1129
  .quad .Laot_word_name_1130
  .quad aot_get_fw_62636d702d69
.section .rodata
.Laot_word_name_1131:
  .byte 58
  .byte 98
  .byte 99
  .byte 109
  .byte 112
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_1131:
  .quad .Laot_word_entry_1130
  .quad .Laot_word_name_1131
  .quad aot_set_fw_62636d702d69
.section .text
aot_get_fw_62636f70792d61:
  leaq reg_fw_62636f70792d61(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_62636f70792d61:
  leaq reg_fw_62636f70792d61(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1132:
  .byte 98
  .byte 99
  .byte 111
  .byte 112
  .byte 121
  .byte 45
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_1132:
  .quad .Laot_word_entry_1131
  .quad .Laot_word_name_1132
  .quad aot_get_fw_62636f70792d61
.section .rodata
.Laot_word_name_1133:
  .byte 58
  .byte 98
  .byte 99
  .byte 111
  .byte 112
  .byte 121
  .byte 45
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_1133:
  .quad .Laot_word_entry_1132
  .quad .Laot_word_name_1133
  .quad aot_set_fw_62636f70792d61
.section .text
aot_get_fw_62636f70792d69:
  leaq reg_fw_62636f70792d69(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_62636f70792d69:
  leaq reg_fw_62636f70792d69(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1134:
  .byte 98
  .byte 99
  .byte 111
  .byte 112
  .byte 121
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_1134:
  .quad .Laot_word_entry_1133
  .quad .Laot_word_name_1134
  .quad aot_get_fw_62636f70792d69
.section .rodata
.Laot_word_name_1135:
  .byte 58
  .byte 98
  .byte 99
  .byte 111
  .byte 112
  .byte 121
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_1135:
  .quad .Laot_word_entry_1134
  .quad .Laot_word_name_1135
  .quad aot_set_fw_62636f70792d69
.section .text
aot_get_fw_62636f70792d72:
  leaq reg_fw_62636f70792d72(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_62636f70792d72:
  leaq reg_fw_62636f70792d72(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1136:
  .byte 98
  .byte 99
  .byte 111
  .byte 112
  .byte 121
  .byte 45
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_1136:
  .quad .Laot_word_entry_1135
  .quad .Laot_word_name_1136
  .quad aot_get_fw_62636f70792d72
.section .rodata
.Laot_word_name_1137:
  .byte 58
  .byte 98
  .byte 99
  .byte 111
  .byte 112
  .byte 121
  .byte 45
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_1137:
  .quad .Laot_word_entry_1136
  .quad .Laot_word_name_1137
  .quad aot_set_fw_62636f70792d72
.section .text
aot_get_fw_626469672d69:
  leaq reg_fw_626469672d69(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_626469672d69:
  leaq reg_fw_626469672d69(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1138:
  .byte 98
  .byte 100
  .byte 105
  .byte 103
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_1138:
  .quad .Laot_word_entry_1137
  .quad .Laot_word_name_1138
  .quad aot_get_fw_626469672d69
.section .rodata
.Laot_word_name_1139:
  .byte 58
  .byte 98
  .byte 100
  .byte 105
  .byte 103
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_1139:
  .quad .Laot_word_entry_1138
  .quad .Laot_word_name_1139
  .quad aot_set_fw_626469672d69
.section .text
aot_get_fw_626469672d70:
  leaq reg_fw_626469672d70(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_626469672d70:
  leaq reg_fw_626469672d70(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1140:
  .byte 98
  .byte 100
  .byte 105
  .byte 103
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1140:
  .quad .Laot_word_entry_1139
  .quad .Laot_word_name_1140
  .quad aot_get_fw_626469672d70
.section .rodata
.Laot_word_name_1141:
  .byte 58
  .byte 98
  .byte 100
  .byte 105
  .byte 103
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1141:
  .quad .Laot_word_entry_1140
  .quad .Laot_word_name_1141
  .quad aot_set_fw_626469672d70
.section .text
aot_get_fw_626469762d64:
  leaq reg_fw_626469762d64(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_626469762d64:
  leaq reg_fw_626469762d64(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1142:
  .byte 98
  .byte 100
  .byte 105
  .byte 118
  .byte 45
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_1142:
  .quad .Laot_word_entry_1141
  .quad .Laot_word_name_1142
  .quad aot_get_fw_626469762d64
.section .rodata
.Laot_word_name_1143:
  .byte 58
  .byte 98
  .byte 100
  .byte 105
  .byte 118
  .byte 45
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_1143:
  .quad .Laot_word_entry_1142
  .quad .Laot_word_name_1143
  .quad aot_set_fw_626469762d64
.section .text
aot_get_fw_626469762d69:
  leaq reg_fw_626469762d69(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_626469762d69:
  leaq reg_fw_626469762d69(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1144:
  .byte 98
  .byte 100
  .byte 105
  .byte 118
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_1144:
  .quad .Laot_word_entry_1143
  .quad .Laot_word_name_1144
  .quad aot_get_fw_626469762d69
.section .rodata
.Laot_word_name_1145:
  .byte 58
  .byte 98
  .byte 100
  .byte 105
  .byte 118
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_1145:
  .quad .Laot_word_entry_1144
  .quad .Laot_word_name_1145
  .quad aot_set_fw_626469762d69
.section .text
aot_get_fw_626469762d70:
  leaq reg_fw_626469762d70(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_626469762d70:
  leaq reg_fw_626469762d70(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1146:
  .byte 98
  .byte 100
  .byte 105
  .byte 118
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1146:
  .quad .Laot_word_entry_1145
  .quad .Laot_word_name_1146
  .quad aot_get_fw_626469762d70
.section .rodata
.Laot_word_name_1147:
  .byte 58
  .byte 98
  .byte 100
  .byte 105
  .byte 118
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1147:
  .quad .Laot_word_entry_1146
  .quad .Laot_word_name_1147
  .quad aot_set_fw_626469762d70
.section .text
aot_get_fw_626469762d72656d:
  leaq reg_fw_626469762d72656d(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_626469762d72656d:
  leaq reg_fw_626469762d72656d(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1148:
  .byte 98
  .byte 100
  .byte 105
  .byte 118
  .byte 45
  .byte 114
  .byte 101
  .byte 109
  .byte 0
.section .data
.Laot_word_entry_1148:
  .quad .Laot_word_entry_1147
  .quad .Laot_word_name_1148
  .quad aot_get_fw_626469762d72656d
.section .rodata
.Laot_word_name_1149:
  .byte 58
  .byte 98
  .byte 100
  .byte 105
  .byte 118
  .byte 45
  .byte 114
  .byte 101
  .byte 109
  .byte 0
.section .data
.Laot_word_entry_1149:
  .quad .Laot_word_entry_1148
  .quad .Laot_word_name_1149
  .quad aot_set_fw_626469762d72656d
.section .text
aot_get_fw_626469762d76:
  leaq reg_fw_626469762d76(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_626469762d76:
  leaq reg_fw_626469762d76(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1150:
  .byte 98
  .byte 100
  .byte 105
  .byte 118
  .byte 45
  .byte 118
  .byte 0
.section .data
.Laot_word_entry_1150:
  .quad .Laot_word_entry_1149
  .quad .Laot_word_name_1150
  .quad aot_get_fw_626469762d76
.section .rodata
.Laot_word_name_1151:
  .byte 58
  .byte 98
  .byte 100
  .byte 105
  .byte 118
  .byte 45
  .byte 118
  .byte 0
.section .data
.Laot_word_entry_1151:
  .quad .Laot_word_entry_1150
  .quad .Laot_word_name_1151
  .quad aot_set_fw_626469762d76
.section .text
aot_get_fw_6266726f6d2d69:
  leaq reg_fw_6266726f6d2d69(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6266726f6d2d69:
  leaq reg_fw_6266726f6d2d69(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1152:
  .byte 98
  .byte 102
  .byte 114
  .byte 111
  .byte 109
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_1152:
  .quad .Laot_word_entry_1151
  .quad .Laot_word_name_1152
  .quad aot_get_fw_6266726f6d2d69
.section .rodata
.Laot_word_name_1153:
  .byte 58
  .byte 98
  .byte 102
  .byte 114
  .byte 111
  .byte 109
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_1153:
  .quad .Laot_word_entry_1152
  .quad .Laot_word_name_1153
  .quad aot_set_fw_6266726f6d2d69
.section .text
aot_get_fw_6266726f6d2d70:
  leaq reg_fw_6266726f6d2d70(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6266726f6d2d70:
  leaq reg_fw_6266726f6d2d70(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1154:
  .byte 98
  .byte 102
  .byte 114
  .byte 111
  .byte 109
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1154:
  .quad .Laot_word_entry_1153
  .quad .Laot_word_name_1154
  .quad aot_get_fw_6266726f6d2d70
.section .rodata
.Laot_word_name_1155:
  .byte 58
  .byte 98
  .byte 102
  .byte 114
  .byte 111
  .byte 109
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1155:
  .quad .Laot_word_entry_1154
  .quad .Laot_word_name_1155
  .quad aot_set_fw_6266726f6d2d70
.section .text
aot_get_fw_6266726f6d2d76:
  leaq reg_fw_6266726f6d2d76(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6266726f6d2d76:
  leaq reg_fw_6266726f6d2d76(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1156:
  .byte 98
  .byte 102
  .byte 114
  .byte 111
  .byte 109
  .byte 45
  .byte 118
  .byte 0
.section .data
.Laot_word_entry_1156:
  .quad .Laot_word_entry_1155
  .quad .Laot_word_name_1156
  .quad aot_get_fw_6266726f6d2d76
.section .rodata
.Laot_word_name_1157:
  .byte 58
  .byte 98
  .byte 102
  .byte 114
  .byte 111
  .byte 109
  .byte 45
  .byte 118
  .byte 0
.section .data
.Laot_word_entry_1157:
  .quad .Laot_word_entry_1156
  .quad .Laot_word_name_1157
  .quad aot_set_fw_6266726f6d2d76
.section .text
aot_get_fw_626c656e2d70:
  leaq reg_fw_626c656e2d70(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_626c656e2d70:
  leaq reg_fw_626c656e2d70(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1158:
  .byte 98
  .byte 108
  .byte 101
  .byte 110
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1158:
  .quad .Laot_word_entry_1157
  .quad .Laot_word_name_1158
  .quad aot_get_fw_626c656e2d70
.section .rodata
.Laot_word_name_1159:
  .byte 58
  .byte 98
  .byte 108
  .byte 101
  .byte 110
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1159:
  .quad .Laot_word_entry_1158
  .quad .Laot_word_name_1159
  .quad aot_set_fw_626c656e2d70
.section .text
aot_get_fw_626d756c2d61:
  leaq reg_fw_626d756c2d61(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_626d756c2d61:
  leaq reg_fw_626d756c2d61(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1160:
  .byte 98
  .byte 109
  .byte 117
  .byte 108
  .byte 45
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_1160:
  .quad .Laot_word_entry_1159
  .quad .Laot_word_name_1160
  .quad aot_get_fw_626d756c2d61
.section .rodata
.Laot_word_name_1161:
  .byte 58
  .byte 98
  .byte 109
  .byte 117
  .byte 108
  .byte 45
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_1161:
  .quad .Laot_word_entry_1160
  .quad .Laot_word_name_1161
  .quad aot_set_fw_626d756c2d61
.section .text
aot_get_fw_626d756c2d62:
  leaq reg_fw_626d756c2d62(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_626d756c2d62:
  leaq reg_fw_626d756c2d62(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1162:
  .byte 98
  .byte 109
  .byte 117
  .byte 108
  .byte 45
  .byte 98
  .byte 0
.section .data
.Laot_word_entry_1162:
  .quad .Laot_word_entry_1161
  .quad .Laot_word_name_1162
  .quad aot_get_fw_626d756c2d62
.section .rodata
.Laot_word_name_1163:
  .byte 58
  .byte 98
  .byte 109
  .byte 117
  .byte 108
  .byte 45
  .byte 98
  .byte 0
.section .data
.Laot_word_entry_1163:
  .quad .Laot_word_entry_1162
  .quad .Laot_word_name_1163
  .quad aot_set_fw_626d756c2d62
.section .text
aot_get_fw_626d756c2d6361727279:
  leaq reg_fw_626d756c2d6361727279(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_626d756c2d6361727279:
  leaq reg_fw_626d756c2d6361727279(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1164:
  .byte 98
  .byte 109
  .byte 117
  .byte 108
  .byte 45
  .byte 99
  .byte 97
  .byte 114
  .byte 114
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_1164:
  .quad .Laot_word_entry_1163
  .quad .Laot_word_name_1164
  .quad aot_get_fw_626d756c2d6361727279
.section .rodata
.Laot_word_name_1165:
  .byte 58
  .byte 98
  .byte 109
  .byte 117
  .byte 108
  .byte 45
  .byte 99
  .byte 97
  .byte 114
  .byte 114
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_1165:
  .quad .Laot_word_entry_1164
  .quad .Laot_word_name_1165
  .quad aot_set_fw_626d756c2d6361727279
.section .text
aot_get_fw_626d756c2d69:
  leaq reg_fw_626d756c2d69(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_626d756c2d69:
  leaq reg_fw_626d756c2d69(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1166:
  .byte 98
  .byte 109
  .byte 117
  .byte 108
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_1166:
  .quad .Laot_word_entry_1165
  .quad .Laot_word_name_1166
  .quad aot_get_fw_626d756c2d69
.section .rodata
.Laot_word_name_1167:
  .byte 58
  .byte 98
  .byte 109
  .byte 117
  .byte 108
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_1167:
  .quad .Laot_word_entry_1166
  .quad .Laot_word_name_1167
  .quad aot_set_fw_626d756c2d69
.section .text
aot_get_fw_626d756c2d6a:
  leaq reg_fw_626d756c2d6a(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_626d756c2d6a:
  leaq reg_fw_626d756c2d6a(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1168:
  .byte 98
  .byte 109
  .byte 117
  .byte 108
  .byte 45
  .byte 106
  .byte 0
.section .data
.Laot_word_entry_1168:
  .quad .Laot_word_entry_1167
  .quad .Laot_word_name_1168
  .quad aot_get_fw_626d756c2d6a
.section .rodata
.Laot_word_name_1169:
  .byte 58
  .byte 98
  .byte 109
  .byte 117
  .byte 108
  .byte 45
  .byte 106
  .byte 0
.section .data
.Laot_word_entry_1169:
  .quad .Laot_word_entry_1168
  .quad .Laot_word_name_1169
  .quad aot_set_fw_626d756c2d6a
.section .text
aot_get_fw_626d756c2d6b:
  leaq reg_fw_626d756c2d6b(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_626d756c2d6b:
  leaq reg_fw_626d756c2d6b(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1170:
  .byte 98
  .byte 109
  .byte 117
  .byte 108
  .byte 45
  .byte 107
  .byte 0
.section .data
.Laot_word_entry_1170:
  .quad .Laot_word_entry_1169
  .quad .Laot_word_name_1170
  .quad aot_get_fw_626d756c2d6b
.section .rodata
.Laot_word_name_1171:
  .byte 58
  .byte 98
  .byte 109
  .byte 117
  .byte 108
  .byte 45
  .byte 107
  .byte 0
.section .data
.Laot_word_entry_1171:
  .quad .Laot_word_entry_1170
  .quad .Laot_word_name_1171
  .quad aot_set_fw_626d756c2d6b
.section .text
aot_get_fw_626d756c2d6e:
  leaq reg_fw_626d756c2d6e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_626d756c2d6e:
  leaq reg_fw_626d756c2d6e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1172:
  .byte 98
  .byte 109
  .byte 117
  .byte 108
  .byte 45
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_1172:
  .quad .Laot_word_entry_1171
  .quad .Laot_word_name_1172
  .quad aot_get_fw_626d756c2d6e
.section .rodata
.Laot_word_name_1173:
  .byte 58
  .byte 98
  .byte 109
  .byte 117
  .byte 108
  .byte 45
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_1173:
  .quad .Laot_word_entry_1172
  .quad .Laot_word_name_1173
  .quad aot_set_fw_626d756c2d6e
.section .text
aot_get_fw_626d756c2d72:
  leaq reg_fw_626d756c2d72(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_626d756c2d72:
  leaq reg_fw_626d756c2d72(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1174:
  .byte 98
  .byte 109
  .byte 117
  .byte 108
  .byte 45
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_1174:
  .quad .Laot_word_entry_1173
  .quad .Laot_word_name_1174
  .quad aot_get_fw_626d756c2d72
.section .rodata
.Laot_word_name_1175:
  .byte 58
  .byte 98
  .byte 109
  .byte 117
  .byte 108
  .byte 45
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_1175:
  .quad .Laot_word_entry_1174
  .quad .Laot_word_name_1175
  .quad aot_set_fw_626d756c2d72
.section .text
aot_get_fw_626d756c2d73:
  leaq reg_fw_626d756c2d73(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_626d756c2d73:
  leaq reg_fw_626d756c2d73(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1176:
  .byte 98
  .byte 109
  .byte 117
  .byte 108
  .byte 45
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_1176:
  .quad .Laot_word_entry_1175
  .quad .Laot_word_name_1176
  .quad aot_get_fw_626d756c2d73
.section .rodata
.Laot_word_name_1177:
  .byte 58
  .byte 98
  .byte 109
  .byte 117
  .byte 108
  .byte 45
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_1177:
  .quad .Laot_word_entry_1176
  .quad .Laot_word_name_1177
  .quad aot_set_fw_626d756c2d73
.section .text
aot_get_fw_626d782d61:
  leaq reg_fw_626d782d61(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_626d782d61:
  leaq reg_fw_626d782d61(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1178:
  .byte 98
  .byte 109
  .byte 120
  .byte 45
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_1178:
  .quad .Laot_word_entry_1177
  .quad .Laot_word_name_1178
  .quad aot_get_fw_626d782d61
.section .rodata
.Laot_word_name_1179:
  .byte 58
  .byte 98
  .byte 109
  .byte 120
  .byte 45
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_1179:
  .quad .Laot_word_entry_1178
  .quad .Laot_word_name_1179
  .quad aot_set_fw_626d782d61
.section .text
aot_get_fw_626d782d62:
  leaq reg_fw_626d782d62(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_626d782d62:
  leaq reg_fw_626d782d62(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1180:
  .byte 98
  .byte 109
  .byte 120
  .byte 45
  .byte 98
  .byte 0
.section .data
.Laot_word_entry_1180:
  .quad .Laot_word_entry_1179
  .quad .Laot_word_name_1180
  .quad aot_get_fw_626d782d62
.section .rodata
.Laot_word_name_1181:
  .byte 58
  .byte 98
  .byte 109
  .byte 120
  .byte 45
  .byte 98
  .byte 0
.section .data
.Laot_word_entry_1181:
  .quad .Laot_word_entry_1180
  .quad .Laot_word_name_1181
  .quad aot_set_fw_626d782d62
.section .text
aot_get_fw_626e65772d636170:
  leaq reg_fw_626e65772d636170(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_626e65772d636170:
  leaq reg_fw_626e65772d636170(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1182:
  .byte 98
  .byte 110
  .byte 101
  .byte 119
  .byte 45
  .byte 99
  .byte 97
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1182:
  .quad .Laot_word_entry_1181
  .quad .Laot_word_name_1182
  .quad aot_get_fw_626e65772d636170
.section .rodata
.Laot_word_name_1183:
  .byte 58
  .byte 98
  .byte 110
  .byte 101
  .byte 119
  .byte 45
  .byte 99
  .byte 97
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1183:
  .quad .Laot_word_entry_1182
  .quad .Laot_word_name_1183
  .quad aot_set_fw_626e65772d636170
.section .text
aot_get_fw_626e65772d656e64:
  leaq reg_fw_626e65772d656e64(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_626e65772d656e64:
  leaq reg_fw_626e65772d656e64(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1184:
  .byte 98
  .byte 110
  .byte 101
  .byte 119
  .byte 45
  .byte 101
  .byte 110
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_1184:
  .quad .Laot_word_entry_1183
  .quad .Laot_word_name_1184
  .quad aot_get_fw_626e65772d656e64
.section .rodata
.Laot_word_name_1185:
  .byte 58
  .byte 98
  .byte 110
  .byte 101
  .byte 119
  .byte 45
  .byte 101
  .byte 110
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_1185:
  .quad .Laot_word_entry_1184
  .quad .Laot_word_name_1185
  .quad aot_set_fw_626e65772d656e64
.section .text
aot_get_fw_626e65772d69:
  leaq reg_fw_626e65772d69(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_626e65772d69:
  leaq reg_fw_626e65772d69(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1186:
  .byte 98
  .byte 110
  .byte 101
  .byte 119
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_1186:
  .quad .Laot_word_entry_1185
  .quad .Laot_word_name_1186
  .quad aot_get_fw_626e65772d69
.section .rodata
.Laot_word_name_1187:
  .byte 58
  .byte 98
  .byte 110
  .byte 101
  .byte 119
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_1187:
  .quad .Laot_word_entry_1186
  .quad .Laot_word_name_1187
  .quad aot_set_fw_626e65772d69
.section .text
aot_get_fw_626e65772d70:
  leaq reg_fw_626e65772d70(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_626e65772d70:
  leaq reg_fw_626e65772d70(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1188:
  .byte 98
  .byte 110
  .byte 101
  .byte 119
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1188:
  .quad .Laot_word_entry_1187
  .quad .Laot_word_name_1188
  .quad aot_get_fw_626e65772d70
.section .rodata
.Laot_word_name_1189:
  .byte 58
  .byte 98
  .byte 110
  .byte 101
  .byte 119
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1189:
  .quad .Laot_word_entry_1188
  .quad .Laot_word_name_1189
  .quad aot_set_fw_626e65772d70
.section .text
aot_get_fw_62706f772d657870:
  leaq reg_fw_62706f772d657870(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_62706f772d657870:
  leaq reg_fw_62706f772d657870(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1190:
  .byte 98
  .byte 112
  .byte 111
  .byte 119
  .byte 45
  .byte 101
  .byte 120
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1190:
  .quad .Laot_word_entry_1189
  .quad .Laot_word_name_1190
  .quad aot_get_fw_62706f772d657870
.section .rodata
.Laot_word_name_1191:
  .byte 58
  .byte 98
  .byte 112
  .byte 111
  .byte 119
  .byte 45
  .byte 101
  .byte 120
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1191:
  .quad .Laot_word_entry_1190
  .quad .Laot_word_name_1191
  .quad aot_set_fw_62706f772d657870
.section .text
aot_get_fw_62706f772d70:
  leaq reg_fw_62706f772d70(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_62706f772d70:
  leaq reg_fw_62706f772d70(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1192:
  .byte 98
  .byte 112
  .byte 111
  .byte 119
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1192:
  .quad .Laot_word_entry_1191
  .quad .Laot_word_name_1192
  .quad aot_get_fw_62706f772d70
.section .rodata
.Laot_word_name_1193:
  .byte 58
  .byte 98
  .byte 112
  .byte 111
  .byte 119
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1193:
  .quad .Laot_word_entry_1192
  .quad .Laot_word_name_1193
  .quad aot_set_fw_62706f772d70
.section .text
aot_get_fw_62706f772d72:
  leaq reg_fw_62706f772d72(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_62706f772d72:
  leaq reg_fw_62706f772d72(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1194:
  .byte 98
  .byte 112
  .byte 111
  .byte 119
  .byte 45
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_1194:
  .quad .Laot_word_entry_1193
  .quad .Laot_word_name_1194
  .quad aot_get_fw_62706f772d72
.section .rodata
.Laot_word_name_1195:
  .byte 58
  .byte 98
  .byte 112
  .byte 111
  .byte 119
  .byte 45
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_1195:
  .quad .Laot_word_entry_1194
  .quad .Laot_word_name_1195
  .quad aot_set_fw_62706f772d72
.section .text
aot_get_fw_6270722d6469676974:
  leaq reg_fw_6270722d6469676974(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6270722d6469676974:
  leaq reg_fw_6270722d6469676974(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1196:
  .byte 98
  .byte 112
  .byte 114
  .byte 45
  .byte 100
  .byte 105
  .byte 103
  .byte 105
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_1196:
  .quad .Laot_word_entry_1195
  .quad .Laot_word_name_1196
  .quad aot_get_fw_6270722d6469676974
.section .rodata
.Laot_word_name_1197:
  .byte 58
  .byte 98
  .byte 112
  .byte 114
  .byte 45
  .byte 100
  .byte 105
  .byte 103
  .byte 105
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_1197:
  .quad .Laot_word_entry_1196
  .quad .Laot_word_name_1197
  .quad aot_set_fw_6270722d6469676974
.section .text
aot_get_fw_6270722d70:
  leaq reg_fw_6270722d70(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6270722d70:
  leaq reg_fw_6270722d70(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1198:
  .byte 98
  .byte 112
  .byte 114
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1198:
  .quad .Laot_word_entry_1197
  .quad .Laot_word_name_1198
  .quad aot_get_fw_6270722d70
.section .rodata
.Laot_word_name_1199:
  .byte 58
  .byte 98
  .byte 112
  .byte 114
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1199:
  .quad .Laot_word_entry_1198
  .quad .Laot_word_name_1199
  .quad aot_set_fw_6270722d70
.section .text
aot_get_fw_6270722d73697a65:
  leaq reg_fw_6270722d73697a65(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6270722d73697a65:
  leaq reg_fw_6270722d73697a65(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1200:
  .byte 98
  .byte 112
  .byte 114
  .byte 45
  .byte 115
  .byte 105
  .byte 122
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1200:
  .quad .Laot_word_entry_1199
  .quad .Laot_word_name_1200
  .quad aot_get_fw_6270722d73697a65
.section .rodata
.Laot_word_name_1201:
  .byte 58
  .byte 98
  .byte 112
  .byte 114
  .byte 45
  .byte 115
  .byte 105
  .byte 122
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1201:
  .quad .Laot_word_entry_1200
  .quad .Laot_word_name_1201
  .quad aot_set_fw_6270722d73697a65
.section .text
aot_get_fw_6270722d776f726b:
  leaq reg_fw_6270722d776f726b(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6270722d776f726b:
  leaq reg_fw_6270722d776f726b(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1202:
  .byte 98
  .byte 112
  .byte 114
  .byte 45
  .byte 119
  .byte 111
  .byte 114
  .byte 107
  .byte 0
.section .data
.Laot_word_entry_1202:
  .quad .Laot_word_entry_1201
  .quad .Laot_word_name_1202
  .quad aot_get_fw_6270722d776f726b
.section .rodata
.Laot_word_name_1203:
  .byte 58
  .byte 98
  .byte 112
  .byte 114
  .byte 45
  .byte 119
  .byte 111
  .byte 114
  .byte 107
  .byte 0
.section .data
.Laot_word_entry_1203:
  .quad .Laot_word_entry_1202
  .quad .Laot_word_name_1203
  .quad aot_set_fw_6270722d776f726b
.section .text
aot_get_fw_627075742d69:
  leaq reg_fw_627075742d69(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_627075742d69:
  leaq reg_fw_627075742d69(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1204:
  .byte 98
  .byte 112
  .byte 117
  .byte 116
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_1204:
  .quad .Laot_word_entry_1203
  .quad .Laot_word_name_1204
  .quad aot_get_fw_627075742d69
.section .rodata
.Laot_word_name_1205:
  .byte 58
  .byte 98
  .byte 112
  .byte 117
  .byte 116
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_1205:
  .quad .Laot_word_entry_1204
  .quad .Laot_word_name_1205
  .quad aot_set_fw_627075742d69
.section .text
aot_get_fw_627075742d70:
  leaq reg_fw_627075742d70(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_627075742d70:
  leaq reg_fw_627075742d70(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1206:
  .byte 98
  .byte 112
  .byte 117
  .byte 116
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1206:
  .quad .Laot_word_entry_1205
  .quad .Laot_word_name_1206
  .quad aot_get_fw_627075742d70
.section .rodata
.Laot_word_name_1207:
  .byte 58
  .byte 98
  .byte 112
  .byte 117
  .byte 116
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1207:
  .quad .Laot_word_entry_1206
  .quad .Laot_word_name_1207
  .quad aot_set_fw_627075742d70
.section .text
aot_get_fw_627075742d76:
  leaq reg_fw_627075742d76(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_627075742d76:
  leaq reg_fw_627075742d76(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1208:
  .byte 98
  .byte 112
  .byte 117
  .byte 116
  .byte 45
  .byte 118
  .byte 0
.section .data
.Laot_word_entry_1208:
  .quad .Laot_word_entry_1207
  .quad .Laot_word_name_1208
  .quad aot_get_fw_627075742d76
.section .rodata
.Laot_word_name_1209:
  .byte 58
  .byte 98
  .byte 112
  .byte 117
  .byte 116
  .byte 45
  .byte 118
  .byte 0
.section .data
.Laot_word_entry_1209:
  .quad .Laot_word_entry_1208
  .quad .Laot_word_name_1209
  .quad aot_set_fw_627075742d76
.section .text
aot_get_fw_627375622d61:
  leaq reg_fw_627375622d61(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_627375622d61:
  leaq reg_fw_627375622d61(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1210:
  .byte 98
  .byte 115
  .byte 117
  .byte 98
  .byte 45
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_1210:
  .quad .Laot_word_entry_1209
  .quad .Laot_word_name_1210
  .quad aot_get_fw_627375622d61
.section .rodata
.Laot_word_name_1211:
  .byte 58
  .byte 98
  .byte 115
  .byte 117
  .byte 98
  .byte 45
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_1211:
  .quad .Laot_word_entry_1210
  .quad .Laot_word_name_1211
  .quad aot_set_fw_627375622d61
.section .text
aot_get_fw_627375622d62:
  leaq reg_fw_627375622d62(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_627375622d62:
  leaq reg_fw_627375622d62(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1212:
  .byte 98
  .byte 115
  .byte 117
  .byte 98
  .byte 45
  .byte 98
  .byte 0
.section .data
.Laot_word_entry_1212:
  .quad .Laot_word_entry_1211
  .quad .Laot_word_name_1212
  .quad aot_get_fw_627375622d62
.section .rodata
.Laot_word_name_1213:
  .byte 58
  .byte 98
  .byte 115
  .byte 117
  .byte 98
  .byte 45
  .byte 98
  .byte 0
.section .data
.Laot_word_entry_1213:
  .quad .Laot_word_entry_1212
  .quad .Laot_word_name_1213
  .quad aot_set_fw_627375622d62
.section .text
aot_get_fw_627375622d626f72726f77:
  leaq reg_fw_627375622d626f72726f77(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_627375622d626f72726f77:
  leaq reg_fw_627375622d626f72726f77(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1214:
  .byte 98
  .byte 115
  .byte 117
  .byte 98
  .byte 45
  .byte 98
  .byte 111
  .byte 114
  .byte 114
  .byte 111
  .byte 119
  .byte 0
.section .data
.Laot_word_entry_1214:
  .quad .Laot_word_entry_1213
  .quad .Laot_word_name_1214
  .quad aot_get_fw_627375622d626f72726f77
.section .rodata
.Laot_word_name_1215:
  .byte 58
  .byte 98
  .byte 115
  .byte 117
  .byte 98
  .byte 45
  .byte 98
  .byte 111
  .byte 114
  .byte 114
  .byte 111
  .byte 119
  .byte 0
.section .data
.Laot_word_entry_1215:
  .quad .Laot_word_entry_1214
  .quad .Laot_word_name_1215
  .quad aot_set_fw_627375622d626f72726f77
.section .text
aot_get_fw_627375622d64:
  leaq reg_fw_627375622d64(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_627375622d64:
  leaq reg_fw_627375622d64(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1216:
  .byte 98
  .byte 115
  .byte 117
  .byte 98
  .byte 45
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_1216:
  .quad .Laot_word_entry_1215
  .quad .Laot_word_name_1216
  .quad aot_get_fw_627375622d64
.section .rodata
.Laot_word_name_1217:
  .byte 58
  .byte 98
  .byte 115
  .byte 117
  .byte 98
  .byte 45
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_1217:
  .quad .Laot_word_entry_1216
  .quad .Laot_word_name_1217
  .quad aot_set_fw_627375622d64
.section .text
aot_get_fw_627375622d69:
  leaq reg_fw_627375622d69(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_627375622d69:
  leaq reg_fw_627375622d69(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1218:
  .byte 98
  .byte 115
  .byte 117
  .byte 98
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_1218:
  .quad .Laot_word_entry_1217
  .quad .Laot_word_name_1218
  .quad aot_get_fw_627375622d69
.section .rodata
.Laot_word_name_1219:
  .byte 58
  .byte 98
  .byte 115
  .byte 117
  .byte 98
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_1219:
  .quad .Laot_word_entry_1218
  .quad .Laot_word_name_1219
  .quad aot_set_fw_627375622d69
.section .text
aot_get_fw_627375622d72:
  leaq reg_fw_627375622d72(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_627375622d72:
  leaq reg_fw_627375622d72(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1220:
  .byte 98
  .byte 115
  .byte 117
  .byte 98
  .byte 45
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_1220:
  .quad .Laot_word_entry_1219
  .quad .Laot_word_name_1220
  .quad aot_get_fw_627375622d72
.section .rodata
.Laot_word_name_1221:
  .byte 58
  .byte 98
  .byte 115
  .byte 117
  .byte 98
  .byte 45
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_1221:
  .quad .Laot_word_entry_1220
  .quad .Laot_word_name_1221
  .quad aot_set_fw_627375622d72
.section .text
aot_get_fw_627472696d2d69:
  leaq reg_fw_627472696d2d69(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_627472696d2d69:
  leaq reg_fw_627472696d2d69(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1222:
  .byte 98
  .byte 116
  .byte 114
  .byte 105
  .byte 109
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_1222:
  .quad .Laot_word_entry_1221
  .quad .Laot_word_name_1222
  .quad aot_get_fw_627472696d2d69
.section .rodata
.Laot_word_name_1223:
  .byte 58
  .byte 98
  .byte 116
  .byte 114
  .byte 105
  .byte 109
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_1223:
  .quad .Laot_word_entry_1222
  .quad .Laot_word_name_1223
  .quad aot_set_fw_627472696d2d69
.section .text
aot_get_fw_627472696d2d70:
  leaq reg_fw_627472696d2d70(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_627472696d2d70:
  leaq reg_fw_627472696d2d70(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1224:
  .byte 98
  .byte 116
  .byte 114
  .byte 105
  .byte 109
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1224:
  .quad .Laot_word_entry_1223
  .quad .Laot_word_name_1224
  .quad aot_get_fw_627472696d2d70
.section .rodata
.Laot_word_name_1225:
  .byte 58
  .byte 98
  .byte 116
  .byte 114
  .byte 105
  .byte 109
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1225:
  .quad .Laot_word_entry_1224
  .quad .Laot_word_name_1225
  .quad aot_set_fw_627472696d2d70
.section .text
aot_get_fw_627a65726f2d70:
  leaq reg_fw_627a65726f2d70(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_627a65726f2d70:
  leaq reg_fw_627a65726f2d70(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1226:
  .byte 98
  .byte 122
  .byte 101
  .byte 114
  .byte 111
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1226:
  .quad .Laot_word_entry_1225
  .quad .Laot_word_name_1226
  .quad aot_get_fw_627a65726f2d70
.section .rodata
.Laot_word_name_1227:
  .byte 58
  .byte 98
  .byte 122
  .byte 101
  .byte 114
  .byte 111
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1227:
  .quad .Laot_word_entry_1226
  .quad .Laot_word_name_1227
  .quad aot_set_fw_627a65726f2d70
.section .text
aot_get_fw_66636c2d65:
  leaq reg_fw_66636c2d65(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_66636c2d65:
  leaq reg_fw_66636c2d65(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1228:
  .byte 102
  .byte 99
  .byte 108
  .byte 45
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1228:
  .quad .Laot_word_entry_1227
  .quad .Laot_word_name_1228
  .quad aot_get_fw_66636c2d65
.section .rodata
.Laot_word_name_1229:
  .byte 58
  .byte 102
  .byte 99
  .byte 108
  .byte 45
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1229:
  .quad .Laot_word_entry_1228
  .quad .Laot_word_name_1229
  .quad aot_set_fw_66636c2d65
.section .text
aot_get_fw_66636c2d6d:
  leaq reg_fw_66636c2d6d(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_66636c2d6d:
  leaq reg_fw_66636c2d6d(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1230:
  .byte 102
  .byte 99
  .byte 108
  .byte 45
  .byte 109
  .byte 0
.section .data
.Laot_word_entry_1230:
  .quad .Laot_word_entry_1229
  .quad .Laot_word_name_1230
  .quad aot_get_fw_66636c2d6d
.section .rodata
.Laot_word_name_1231:
  .byte 58
  .byte 102
  .byte 99
  .byte 108
  .byte 45
  .byte 109
  .byte 0
.section .data
.Laot_word_entry_1231:
  .quad .Laot_word_entry_1230
  .quad .Laot_word_name_1231
  .quad aot_set_fw_66636c2d6d
.section .text
aot_get_fw_66636c2d70:
  leaq reg_fw_66636c2d70(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_66636c2d70:
  leaq reg_fw_66636c2d70(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1232:
  .byte 102
  .byte 99
  .byte 108
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1232:
  .quad .Laot_word_entry_1231
  .quad .Laot_word_name_1232
  .quad aot_get_fw_66636c2d70
.section .rodata
.Laot_word_name_1233:
  .byte 58
  .byte 102
  .byte 99
  .byte 108
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1233:
  .quad .Laot_word_entry_1232
  .quad .Laot_word_name_1233
  .quad aot_set_fw_66636c2d70
.section .text
aot_get_fw_666578702d70:
  leaq reg_fw_666578702d70(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_666578702d70:
  leaq reg_fw_666578702d70(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1234:
  .byte 102
  .byte 101
  .byte 120
  .byte 112
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1234:
  .quad .Laot_word_entry_1233
  .quad .Laot_word_name_1234
  .quad aot_get_fw_666578702d70
.section .rodata
.Laot_word_name_1235:
  .byte 58
  .byte 102
  .byte 101
  .byte 120
  .byte 112
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1235:
  .quad .Laot_word_entry_1234
  .quad .Laot_word_name_1235
  .quad aot_set_fw_666578702d70
.section .text
aot_get_fw_666d616e2d69:
  leaq reg_fw_666d616e2d69(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_666d616e2d69:
  leaq reg_fw_666d616e2d69(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1236:
  .byte 102
  .byte 109
  .byte 97
  .byte 110
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_1236:
  .quad .Laot_word_entry_1235
  .quad .Laot_word_name_1236
  .quad aot_get_fw_666d616e2d69
.section .rodata
.Laot_word_name_1237:
  .byte 58
  .byte 102
  .byte 109
  .byte 97
  .byte 110
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_1237:
  .quad .Laot_word_entry_1236
  .quad .Laot_word_name_1237
  .quad aot_set_fw_666d616e2d69
.section .text
aot_get_fw_666d616e2d70:
  leaq reg_fw_666d616e2d70(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_666d616e2d70:
  leaq reg_fw_666d616e2d70(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1238:
  .byte 102
  .byte 109
  .byte 97
  .byte 110
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1238:
  .quad .Laot_word_entry_1237
  .quad .Laot_word_name_1238
  .quad aot_get_fw_666d616e2d70
.section .rodata
.Laot_word_name_1239:
  .byte 58
  .byte 102
  .byte 109
  .byte 97
  .byte 110
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1239:
  .quad .Laot_word_entry_1238
  .quad .Laot_word_name_1239
  .quad aot_set_fw_666d616e2d70
.section .text
aot_get_fw_666d616e2d7363616c65:
  leaq reg_fw_666d616e2d7363616c65(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_666d616e2d7363616c65:
  leaq reg_fw_666d616e2d7363616c65(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1240:
  .byte 102
  .byte 109
  .byte 97
  .byte 110
  .byte 45
  .byte 115
  .byte 99
  .byte 97
  .byte 108
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1240:
  .quad .Laot_word_entry_1239
  .quad .Laot_word_name_1240
  .quad aot_get_fw_666d616e2d7363616c65
.section .rodata
.Laot_word_name_1241:
  .byte 58
  .byte 102
  .byte 109
  .byte 97
  .byte 110
  .byte 45
  .byte 115
  .byte 99
  .byte 97
  .byte 108
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1241:
  .quad .Laot_word_entry_1240
  .quad .Laot_word_name_1241
  .quad aot_set_fw_666d616e2d7363616c65
.section .text
aot_get_fw_666d616e2d76:
  leaq reg_fw_666d616e2d76(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_666d616e2d76:
  leaq reg_fw_666d616e2d76(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1242:
  .byte 102
  .byte 109
  .byte 97
  .byte 110
  .byte 45
  .byte 118
  .byte 0
.section .data
.Laot_word_entry_1242:
  .quad .Laot_word_entry_1241
  .quad .Laot_word_name_1242
  .quad aot_get_fw_666d616e2d76
.section .rodata
.Laot_word_name_1243:
  .byte 58
  .byte 102
  .byte 109
  .byte 97
  .byte 110
  .byte 45
  .byte 118
  .byte 0
.section .data
.Laot_word_entry_1243:
  .quad .Laot_word_entry_1242
  .quad .Laot_word_name_1243
  .quad aot_set_fw_666d616e2d76
.section .text
aot_get_fw_667265642d65:
  leaq reg_fw_667265642d65(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_667265642d65:
  leaq reg_fw_667265642d65(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1244:
  .byte 102
  .byte 114
  .byte 101
  .byte 100
  .byte 45
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1244:
  .quad .Laot_word_entry_1243
  .quad .Laot_word_name_1244
  .quad aot_get_fw_667265642d65
.section .rodata
.Laot_word_name_1245:
  .byte 58
  .byte 102
  .byte 114
  .byte 101
  .byte 100
  .byte 45
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1245:
  .quad .Laot_word_entry_1244
  .quad .Laot_word_name_1245
  .quad aot_set_fw_667265642d65
.section .text
aot_get_fw_667265642d73:
  leaq reg_fw_667265642d73(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_667265642d73:
  leaq reg_fw_667265642d73(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1246:
  .byte 102
  .byte 114
  .byte 101
  .byte 100
  .byte 45
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_1246:
  .quad .Laot_word_entry_1245
  .quad .Laot_word_name_1246
  .quad aot_get_fw_667265642d73
.section .rodata
.Laot_word_name_1247:
  .byte 58
  .byte 102
  .byte 114
  .byte 101
  .byte 100
  .byte 45
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_1247:
  .quad .Laot_word_entry_1246
  .quad .Laot_word_name_1247
  .quad aot_set_fw_667265642d73
.section .text
aot_get_fw_6673632d65:
  leaq reg_fw_6673632d65(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6673632d65:
  leaq reg_fw_6673632d65(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1248:
  .byte 102
  .byte 115
  .byte 99
  .byte 45
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1248:
  .quad .Laot_word_entry_1247
  .quad .Laot_word_name_1248
  .quad aot_get_fw_6673632d65
.section .rodata
.Laot_word_name_1249:
  .byte 58
  .byte 102
  .byte 115
  .byte 99
  .byte 45
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1249:
  .quad .Laot_word_entry_1248
  .quad .Laot_word_name_1249
  .quad aot_set_fw_6673632d65
.section .text
aot_get_fw_6673632d6d:
  leaq reg_fw_6673632d6d(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6673632d6d:
  leaq reg_fw_6673632d6d(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1250:
  .byte 102
  .byte 115
  .byte 99
  .byte 45
  .byte 109
  .byte 0
.section .data
.Laot_word_entry_1250:
  .quad .Laot_word_entry_1249
  .quad .Laot_word_name_1250
  .quad aot_get_fw_6673632d6d
.section .rodata
.Laot_word_name_1251:
  .byte 58
  .byte 102
  .byte 115
  .byte 99
  .byte 45
  .byte 109
  .byte 0
.section .data
.Laot_word_entry_1251:
  .quad .Laot_word_entry_1250
  .quad .Laot_word_name_1251
  .quad aot_set_fw_6673632d6d
.section .text
aot_get_fw_6673632d70:
  leaq reg_fw_6673632d70(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6673632d70:
  leaq reg_fw_6673632d70(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1252:
  .byte 102
  .byte 115
  .byte 99
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1252:
  .quad .Laot_word_entry_1251
  .quad .Laot_word_name_1252
  .quad aot_get_fw_6673632d70
.section .rodata
.Laot_word_name_1253:
  .byte 58
  .byte 102
  .byte 115
  .byte 99
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1253:
  .quad .Laot_word_entry_1252
  .quad .Laot_word_name_1253
  .quad aot_set_fw_6673632d70
.section .text
aot_get_fw_6673632d7368696674:
  leaq reg_fw_6673632d7368696674(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6673632d7368696674:
  leaq reg_fw_6673632d7368696674(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1254:
  .byte 102
  .byte 115
  .byte 99
  .byte 45
  .byte 115
  .byte 104
  .byte 105
  .byte 102
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_1254:
  .quad .Laot_word_entry_1253
  .quad .Laot_word_name_1254
  .quad aot_get_fw_6673632d7368696674
.section .rodata
.Laot_word_name_1255:
  .byte 58
  .byte 102
  .byte 115
  .byte 99
  .byte 45
  .byte 115
  .byte 104
  .byte 105
  .byte 102
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_1255:
  .quad .Laot_word_entry_1254
  .quad .Laot_word_name_1255
  .quad aot_set_fw_6673632d7368696674
.section .text
aot_get_fw_6673632d76:
  leaq reg_fw_6673632d76(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6673632d76:
  leaq reg_fw_6673632d76(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1256:
  .byte 102
  .byte 115
  .byte 99
  .byte 45
  .byte 118
  .byte 0
.section .data
.Laot_word_entry_1256:
  .quad .Laot_word_entry_1255
  .quad .Laot_word_name_1256
  .quad aot_get_fw_6673632d76
.section .rodata
.Laot_word_name_1257:
  .byte 58
  .byte 102
  .byte 115
  .byte 99
  .byte 45
  .byte 118
  .byte 0
.section .data
.Laot_word_entry_1257:
  .quad .Laot_word_entry_1256
  .quad .Laot_word_name_1257
  .quad aot_set_fw_6673632d76
.section .text
aot_get_fw_667369676e2d70:
  leaq reg_fw_667369676e2d70(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_667369676e2d70:
  leaq reg_fw_667369676e2d70(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1258:
  .byte 102
  .byte 115
  .byte 105
  .byte 103
  .byte 110
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1258:
  .quad .Laot_word_entry_1257
  .quad .Laot_word_name_1258
  .quad aot_get_fw_667369676e2d70
.section .rodata
.Laot_word_name_1259:
  .byte 58
  .byte 102
  .byte 115
  .byte 105
  .byte 103
  .byte 110
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1259:
  .quad .Laot_word_entry_1258
  .quad .Laot_word_name_1259
  .quad aot_set_fw_667369676e2d70
.section .text
aot_get_fw_6674722d636c617373:
  leaq reg_fw_6674722d636c617373(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6674722d636c617373:
  leaq reg_fw_6674722d636c617373(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1260:
  .byte 102
  .byte 116
  .byte 114
  .byte 45
  .byte 99
  .byte 108
  .byte 97
  .byte 115
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_1260:
  .quad .Laot_word_entry_1259
  .quad .Laot_word_name_1260
  .quad aot_get_fw_6674722d636c617373
.section .rodata
.Laot_word_name_1261:
  .byte 58
  .byte 102
  .byte 116
  .byte 114
  .byte 45
  .byte 99
  .byte 108
  .byte 97
  .byte 115
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_1261:
  .quad .Laot_word_entry_1260
  .quad .Laot_word_name_1261
  .quad aot_set_fw_6674722d636c617373
.section .text
aot_get_fw_6674722d64:
  leaq reg_fw_6674722d64(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6674722d64:
  leaq reg_fw_6674722d64(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1262:
  .byte 102
  .byte 116
  .byte 114
  .byte 45
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_1262:
  .quad .Laot_word_entry_1261
  .quad .Laot_word_name_1262
  .quad aot_get_fw_6674722d64
.section .rodata
.Laot_word_name_1263:
  .byte 58
  .byte 102
  .byte 116
  .byte 114
  .byte 45
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_1263:
  .quad .Laot_word_entry_1262
  .quad .Laot_word_name_1263
  .quad aot_set_fw_6674722d64
.section .text
aot_get_fw_6674722d65:
  leaq reg_fw_6674722d65(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6674722d65:
  leaq reg_fw_6674722d65(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1264:
  .byte 102
  .byte 116
  .byte 114
  .byte 45
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1264:
  .quad .Laot_word_entry_1263
  .quad .Laot_word_name_1264
  .quad aot_get_fw_6674722d65
.section .rodata
.Laot_word_name_1265:
  .byte 58
  .byte 102
  .byte 116
  .byte 114
  .byte 45
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1265:
  .quad .Laot_word_entry_1264
  .quad .Laot_word_name_1265
  .quad aot_set_fw_6674722d65
.section .text
aot_get_fw_6674722d70:
  leaq reg_fw_6674722d70(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6674722d70:
  leaq reg_fw_6674722d70(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1266:
  .byte 102
  .byte 116
  .byte 114
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1266:
  .quad .Laot_word_entry_1265
  .quad .Laot_word_name_1266
  .quad aot_get_fw_6674722d70
.section .rodata
.Laot_word_name_1267:
  .byte 58
  .byte 102
  .byte 116
  .byte 114
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1267:
  .quad .Laot_word_entry_1266
  .quad .Laot_word_name_1267
  .quad aot_set_fw_6674722d70
.section .text
aot_get_fw_6674722d73:
  leaq reg_fw_6674722d73(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6674722d73:
  leaq reg_fw_6674722d73(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1268:
  .byte 102
  .byte 116
  .byte 114
  .byte 45
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_1268:
  .quad .Laot_word_entry_1267
  .quad .Laot_word_name_1268
  .quad aot_get_fw_6674722d73
.section .rodata
.Laot_word_name_1269:
  .byte 58
  .byte 102
  .byte 116
  .byte 114
  .byte 45
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_1269:
  .quad .Laot_word_entry_1268
  .quad .Laot_word_name_1269
  .quad aot_set_fw_6674722d73
.section .text
aot_get_fw_6c632d6368:
  leaq reg_fw_6c632d6368(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c632d6368:
  leaq reg_fw_6c632d6368(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1270:
  .byte 108
  .byte 99
  .byte 45
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_1270:
  .quad .Laot_word_entry_1269
  .quad .Laot_word_name_1270
  .quad aot_get_fw_6c632d6368
.section .rodata
.Laot_word_name_1271:
  .byte 58
  .byte 108
  .byte 99
  .byte 45
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_1271:
  .quad .Laot_word_entry_1270
  .quad .Laot_word_name_1271
  .quad aot_set_fw_6c632d6368
.section .text
aot_get_fw_6c632d6572726f72:
  leaq reg_fw_6c632d6572726f72(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c632d6572726f72:
  leaq reg_fw_6c632d6572726f72(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1272:
  .byte 108
  .byte 99
  .byte 45
  .byte 101
  .byte 114
  .byte 114
  .byte 111
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_1272:
  .quad .Laot_word_entry_1271
  .quad .Laot_word_name_1272
  .quad aot_get_fw_6c632d6572726f72
.section .rodata
.Laot_word_name_1273:
  .byte 58
  .byte 108
  .byte 99
  .byte 45
  .byte 101
  .byte 114
  .byte 114
  .byte 111
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_1273:
  .quad .Laot_word_entry_1272
  .quad .Laot_word_name_1273
  .quad aot_set_fw_6c632d6572726f72
.section .text
aot_get_fw_6c632d6c656e:
  leaq reg_fw_6c632d6c656e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c632d6c656e:
  leaq reg_fw_6c632d6c656e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1274:
  .byte 108
  .byte 99
  .byte 45
  .byte 108
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_1274:
  .quad .Laot_word_entry_1273
  .quad .Laot_word_name_1274
  .quad aot_get_fw_6c632d6c656e
.section .rodata
.Laot_word_name_1275:
  .byte 58
  .byte 108
  .byte 99
  .byte 45
  .byte 108
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_1275:
  .quad .Laot_word_entry_1274
  .quad .Laot_word_name_1275
  .quad aot_set_fw_6c632d6c656e
.section .text
aot_get_fw_6c632d70:
  leaq reg_fw_6c632d70(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c632d70:
  leaq reg_fw_6c632d70(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1276:
  .byte 108
  .byte 99
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1276:
  .quad .Laot_word_entry_1275
  .quad .Laot_word_name_1276
  .quad aot_get_fw_6c632d70
.section .rodata
.Laot_word_name_1277:
  .byte 58
  .byte 108
  .byte 99
  .byte 45
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1277:
  .quad .Laot_word_entry_1276
  .quad .Laot_word_name_1277
  .quad aot_set_fw_6c632d70
.section .text
aot_get_fw_6c632d7370:
  leaq reg_fw_6c632d7370(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c632d7370:
  leaq reg_fw_6c632d7370(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1278:
  .byte 108
  .byte 99
  .byte 45
  .byte 115
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1278:
  .quad .Laot_word_entry_1277
  .quad .Laot_word_name_1278
  .quad aot_get_fw_6c632d7370
.section .rodata
.Laot_word_name_1279:
  .byte 58
  .byte 108
  .byte 99
  .byte 45
  .byte 115
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1279:
  .quad .Laot_word_entry_1278
  .quad .Laot_word_name_1279
  .quad aot_set_fw_6c632d7370
.section .text
aot_get_fw_6c632d77616e74:
  leaq reg_fw_6c632d77616e74(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c632d77616e74:
  leaq reg_fw_6c632d77616e74(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1280:
  .byte 108
  .byte 99
  .byte 45
  .byte 119
  .byte 97
  .byte 110
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_1280:
  .quad .Laot_word_entry_1279
  .quad .Laot_word_name_1280
  .quad aot_get_fw_6c632d77616e74
.section .rodata
.Laot_word_name_1281:
  .byte 58
  .byte 108
  .byte 99
  .byte 45
  .byte 119
  .byte 97
  .byte 110
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_1281:
  .quad .Laot_word_entry_1280
  .quad .Laot_word_name_1281
  .quad aot_set_fw_6c632d77616e74
.section .text
aot_get_fw_6c636c6f73652d63:
  leaq reg_fw_6c636c6f73652d63(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c636c6f73652d63:
  leaq reg_fw_6c636c6f73652d63(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1282:
  .byte 108
  .byte 99
  .byte 108
  .byte 111
  .byte 115
  .byte 101
  .byte 45
  .byte 99
  .byte 0
.section .data
.Laot_word_entry_1282:
  .quad .Laot_word_entry_1281
  .quad .Laot_word_name_1282
  .quad aot_get_fw_6c636c6f73652d63
.section .rodata
.Laot_word_name_1283:
  .byte 58
  .byte 108
  .byte 99
  .byte 108
  .byte 111
  .byte 115
  .byte 101
  .byte 45
  .byte 99
  .byte 0
.section .data
.Laot_word_entry_1283:
  .quad .Laot_word_entry_1282
  .quad .Laot_word_name_1283
  .quad aot_set_fw_6c636c6f73652d63
.section .text
aot_get_fw_6c642d6368:
  leaq reg_fw_6c642d6368(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c642d6368:
  leaq reg_fw_6c642d6368(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1284:
  .byte 108
  .byte 100
  .byte 45
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_1284:
  .quad .Laot_word_entry_1283
  .quad .Laot_word_name_1284
  .quad aot_get_fw_6c642d6368
.section .rodata
.Laot_word_name_1285:
  .byte 58
  .byte 108
  .byte 100
  .byte 45
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_1285:
  .quad .Laot_word_entry_1284
  .quad .Laot_word_name_1285
  .quad aot_set_fw_6c642d6368
.section .text
aot_get_fw_6c66696e6973682d63:
  leaq reg_fw_6c66696e6973682d63(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c66696e6973682d63:
  leaq reg_fw_6c66696e6973682d63(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1286:
  .byte 108
  .byte 102
  .byte 105
  .byte 110
  .byte 105
  .byte 115
  .byte 104
  .byte 45
  .byte 99
  .byte 0
.section .data
.Laot_word_entry_1286:
  .quad .Laot_word_entry_1285
  .quad .Laot_word_name_1286
  .quad aot_get_fw_6c66696e6973682d63
.section .rodata
.Laot_word_name_1287:
  .byte 58
  .byte 108
  .byte 102
  .byte 105
  .byte 110
  .byte 105
  .byte 115
  .byte 104
  .byte 45
  .byte 99
  .byte 0
.section .data
.Laot_word_entry_1287:
  .quad .Laot_word_entry_1286
  .quad .Laot_word_name_1287
  .quad aot_set_fw_6c66696e6973682d63
.section .text
aot_get_fw_6c6f702d6368:
  leaq reg_fw_6c6f702d6368(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c6f702d6368:
  leaq reg_fw_6c6f702d6368(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1288:
  .byte 108
  .byte 111
  .byte 112
  .byte 45
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_1288:
  .quad .Laot_word_entry_1287
  .quad .Laot_word_name_1288
  .quad aot_get_fw_6c6f702d6368
.section .rodata
.Laot_word_name_1289:
  .byte 58
  .byte 108
  .byte 111
  .byte 112
  .byte 45
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_1289:
  .quad .Laot_word_entry_1288
  .quad .Laot_word_name_1289
  .quad aot_set_fw_6c6f702d6368
.section .text
aot_get_fw_6c6f70657261746f722d6368:
  leaq reg_fw_6c6f70657261746f722d6368(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c6f70657261746f722d6368:
  leaq reg_fw_6c6f70657261746f722d6368(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1290:
  .byte 108
  .byte 111
  .byte 112
  .byte 101
  .byte 114
  .byte 97
  .byte 116
  .byte 111
  .byte 114
  .byte 45
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_1290:
  .quad .Laot_word_entry_1289
  .quad .Laot_word_name_1290
  .quad aot_get_fw_6c6f70657261746f722d6368
.section .rodata
.Laot_word_name_1291:
  .byte 58
  .byte 108
  .byte 111
  .byte 112
  .byte 101
  .byte 114
  .byte 97
  .byte 116
  .byte 111
  .byte 114
  .byte 45
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_1291:
  .quad .Laot_word_entry_1290
  .quad .Laot_word_name_1291
  .quad aot_set_fw_6c6f70657261746f722d6368
.section .text
aot_get_fw_6c6f70657261746f722d746f70:
  leaq reg_fw_6c6f70657261746f722d746f70(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c6f70657261746f722d746f70:
  leaq reg_fw_6c6f70657261746f722d746f70(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1292:
  .byte 108
  .byte 111
  .byte 112
  .byte 101
  .byte 114
  .byte 97
  .byte 116
  .byte 111
  .byte 114
  .byte 45
  .byte 116
  .byte 111
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1292:
  .quad .Laot_word_entry_1291
  .quad .Laot_word_name_1292
  .quad aot_get_fw_6c6f70657261746f722d746f70
.section .rodata
.Laot_word_name_1293:
  .byte 58
  .byte 108
  .byte 111
  .byte 112
  .byte 101
  .byte 114
  .byte 97
  .byte 116
  .byte 111
  .byte 114
  .byte 45
  .byte 116
  .byte 111
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1293:
  .quad .Laot_word_entry_1292
  .quad .Laot_word_name_1293
  .quad aot_set_fw_6c6f70657261746f722d746f70
.section .text
aot_get_fw_6c70632d6368:
  leaq reg_fw_6c70632d6368(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c70632d6368:
  leaq reg_fw_6c70632d6368(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1294:
  .byte 108
  .byte 112
  .byte 99
  .byte 45
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_1294:
  .quad .Laot_word_entry_1293
  .quad .Laot_word_name_1294
  .quad aot_get_fw_6c70632d6368
.section .rodata
.Laot_word_name_1295:
  .byte 58
  .byte 108
  .byte 112
  .byte 99
  .byte 45
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_1295:
  .quad .Laot_word_entry_1294
  .quad .Laot_word_name_1295
  .quad aot_set_fw_6c70632d6368
.section .text
aot_get_fw_6c707573682d6368:
  leaq reg_fw_6c707573682d6368(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c707573682d6368:
  leaq reg_fw_6c707573682d6368(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1296:
  .byte 108
  .byte 112
  .byte 117
  .byte 115
  .byte 104
  .byte 45
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_1296:
  .quad .Laot_word_entry_1295
  .quad .Laot_word_name_1296
  .quad aot_get_fw_6c707573682d6368
.section .rodata
.Laot_word_name_1297:
  .byte 58
  .byte 108
  .byte 112
  .byte 117
  .byte 115
  .byte 104
  .byte 45
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_1297:
  .quad .Laot_word_entry_1296
  .quad .Laot_word_name_1297
  .quad aot_set_fw_6c707573682d6368
.section .text
aot_get_fw_6c7075742d6368:
  leaq reg_fw_6c7075742d6368(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c7075742d6368:
  leaq reg_fw_6c7075742d6368(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1298:
  .byte 108
  .byte 112
  .byte 117
  .byte 116
  .byte 45
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_1298:
  .quad .Laot_word_entry_1297
  .quad .Laot_word_name_1298
  .quad aot_get_fw_6c7075742d6368
.section .rodata
.Laot_word_name_1299:
  .byte 58
  .byte 108
  .byte 112
  .byte 117
  .byte 116
  .byte 45
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_1299:
  .quad .Laot_word_entry_1298
  .quad .Laot_word_name_1299
  .quad aot_set_fw_6c7075742d6368
.section .text
aot_get_fw_6c72756e2d636f6465:
  leaq reg_fw_6c72756e2d636f6465(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6c72756e2d636f6465:
  leaq reg_fw_6c72756e2d636f6465(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1300:
  .byte 108
  .byte 114
  .byte 117
  .byte 110
  .byte 45
  .byte 99
  .byte 111
  .byte 100
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1300:
  .quad .Laot_word_entry_1299
  .quad .Laot_word_name_1300
  .quad aot_get_fw_6c72756e2d636f6465
.section .rodata
.Laot_word_name_1301:
  .byte 58
  .byte 108
  .byte 114
  .byte 117
  .byte 110
  .byte 45
  .byte 99
  .byte 111
  .byte 100
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1301:
  .quad .Laot_word_entry_1300
  .quad .Laot_word_name_1301
  .quad aot_set_fw_6c72756e2d636f6465
.section .text
aot_get_fw_706b672d6c6f61646564:
  leaq reg_fw_706b672d6c6f61646564(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_706b672d6c6f61646564:
  leaq reg_fw_706b672d6c6f61646564(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1302:
  .byte 112
  .byte 107
  .byte 103
  .byte 45
  .byte 108
  .byte 111
  .byte 97
  .byte 100
  .byte 101
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_1302:
  .quad .Laot_word_entry_1301
  .quad .Laot_word_name_1302
  .quad aot_get_fw_706b672d6c6f61646564
.section .rodata
.Laot_word_name_1303:
  .byte 58
  .byte 112
  .byte 107
  .byte 103
  .byte 45
  .byte 108
  .byte 111
  .byte 97
  .byte 100
  .byte 101
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_1303:
  .quad .Laot_word_entry_1302
  .quad .Laot_word_name_1303
  .quad aot_set_fw_706b672d6c6f61646564
.section .text
aot_get_fw_706b672d6e616d65:
  leaq reg_fw_706b672d6e616d65(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_706b672d6e616d65:
  leaq reg_fw_706b672d6e616d65(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1304:
  .byte 112
  .byte 107
  .byte 103
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1304:
  .quad .Laot_word_entry_1303
  .quad .Laot_word_name_1304
  .quad aot_get_fw_706b672d6e616d65
.section .rodata
.Laot_word_name_1305:
  .byte 58
  .byte 112
  .byte 107
  .byte 103
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1305:
  .quad .Laot_word_entry_1304
  .quad .Laot_word_name_1305
  .quad aot_set_fw_706b672d6e616d65
.section .text
aot_get_fw_706b672d736f75726365:
  leaq reg_fw_706b672d736f75726365(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_706b672d736f75726365:
  leaq reg_fw_706b672d736f75726365(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1306:
  .byte 112
  .byte 107
  .byte 103
  .byte 45
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1306:
  .quad .Laot_word_entry_1305
  .quad .Laot_word_name_1306
  .quad aot_get_fw_706b672d736f75726365
.section .rodata
.Laot_word_name_1307:
  .byte 58
  .byte 112
  .byte 107
  .byte 103
  .byte 45
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1307:
  .quad .Laot_word_entry_1306
  .quad .Laot_word_name_1307
  .quad aot_set_fw_706b672d736f75726365
.section .text
aot_get_fw_75313670:
  leaq reg_fw_75313670(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_75313670:
  leaq reg_fw_75313670(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1308:
  .byte 117
  .byte 49
  .byte 54
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1308:
  .quad .Laot_word_entry_1307
  .quad .Laot_word_name_1308
  .quad aot_get_fw_75313670
.section .rodata
.Laot_word_name_1309:
  .byte 58
  .byte 117
  .byte 49
  .byte 54
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1309:
  .quad .Laot_word_entry_1308
  .quad .Laot_word_name_1309
  .quad aot_set_fw_75313670
.section .text
aot_get_fw_75313676:
  leaq reg_fw_75313676(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_75313676:
  leaq reg_fw_75313676(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1310:
  .byte 117
  .byte 49
  .byte 54
  .byte 118
  .byte 0
.section .data
.Laot_word_entry_1310:
  .quad .Laot_word_entry_1309
  .quad .Laot_word_name_1310
  .quad aot_get_fw_75313676
.section .rodata
.Laot_word_name_1311:
  .byte 58
  .byte 117
  .byte 49
  .byte 54
  .byte 118
  .byte 0
.section .data
.Laot_word_entry_1311:
  .quad .Laot_word_entry_1310
  .quad .Laot_word_name_1311
  .quad aot_set_fw_75313676
.section .text
aot_get_fw_75333270:
  leaq reg_fw_75333270(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_75333270:
  leaq reg_fw_75333270(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1312:
  .byte 117
  .byte 51
  .byte 50
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1312:
  .quad .Laot_word_entry_1311
  .quad .Laot_word_name_1312
  .quad aot_get_fw_75333270
.section .rodata
.Laot_word_name_1313:
  .byte 58
  .byte 117
  .byte 51
  .byte 50
  .byte 112
  .byte 0
.section .data
.Laot_word_entry_1313:
  .quad .Laot_word_entry_1312
  .quad .Laot_word_name_1313
  .quad aot_set_fw_75333270
.section .text
aot_get_fw_75333276:
  leaq reg_fw_75333276(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_75333276:
  leaq reg_fw_75333276(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1314:
  .byte 117
  .byte 51
  .byte 50
  .byte 118
  .byte 0
.section .data
.Laot_word_entry_1314:
  .quad .Laot_word_entry_1313
  .quad .Laot_word_name_1314
  .quad aot_get_fw_75333276
.section .rodata
.Laot_word_name_1315:
  .byte 58
  .byte 117
  .byte 51
  .byte 50
  .byte 118
  .byte 0
.section .data
.Laot_word_entry_1315:
  .quad .Laot_word_entry_1314
  .quad .Laot_word_name_1315
  .quad aot_set_fw_75333276
.section .text
aot_get_fw_6964652d6174:
  leaq reg_fw_6964652d6174(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6964652d6174:
  leaq reg_fw_6964652d6174(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1316:
  .byte 105
  .byte 100
  .byte 101
  .byte 45
  .byte 97
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_1316:
  .quad .Laot_word_entry_1315
  .quad .Laot_word_name_1316
  .quad aot_get_fw_6964652d6174
.section .rodata
.Laot_word_name_1317:
  .byte 58
  .byte 105
  .byte 100
  .byte 101
  .byte 45
  .byte 97
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_1317:
  .quad .Laot_word_entry_1316
  .quad .Laot_word_name_1317
  .quad aot_set_fw_6964652d6174
.section .text
aot_get_fw_6964652d637572736f72:
  leaq reg_fw_6964652d637572736f72(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6964652d637572736f72:
  leaq reg_fw_6964652d637572736f72(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1318:
  .byte 105
  .byte 100
  .byte 101
  .byte 45
  .byte 99
  .byte 117
  .byte 114
  .byte 115
  .byte 111
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_1318:
  .quad .Laot_word_entry_1317
  .quad .Laot_word_name_1318
  .quad aot_get_fw_6964652d637572736f72
.section .rodata
.Laot_word_name_1319:
  .byte 58
  .byte 105
  .byte 100
  .byte 101
  .byte 45
  .byte 99
  .byte 117
  .byte 114
  .byte 115
  .byte 111
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_1319:
  .quad .Laot_word_entry_1318
  .quad .Laot_word_name_1319
  .quad aot_set_fw_6964652d637572736f72
.section .text
aot_get_fw_6964652d66696c65:
  leaq reg_fw_6964652d66696c65(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6964652d66696c65:
  leaq reg_fw_6964652d66696c65(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1320:
  .byte 105
  .byte 100
  .byte 101
  .byte 45
  .byte 102
  .byte 105
  .byte 108
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1320:
  .quad .Laot_word_entry_1319
  .quad .Laot_word_name_1320
  .quad aot_get_fw_6964652d66696c65
.section .rodata
.Laot_word_name_1321:
  .byte 58
  .byte 105
  .byte 100
  .byte 101
  .byte 45
  .byte 102
  .byte 105
  .byte 108
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1321:
  .quad .Laot_word_entry_1320
  .quad .Laot_word_name_1321
  .quad aot_set_fw_6964652d66696c65
.section .text
aot_get_fw_6964652d66696c656e616d65:
  leaq reg_fw_6964652d66696c656e616d65(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6964652d66696c656e616d65:
  leaq reg_fw_6964652d66696c656e616d65(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1322:
  .byte 105
  .byte 100
  .byte 101
  .byte 45
  .byte 102
  .byte 105
  .byte 108
  .byte 101
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1322:
  .quad .Laot_word_entry_1321
  .quad .Laot_word_name_1322
  .quad aot_get_fw_6964652d66696c656e616d65
.section .rodata
.Laot_word_name_1323:
  .byte 58
  .byte 105
  .byte 100
  .byte 101
  .byte 45
  .byte 102
  .byte 105
  .byte 108
  .byte 101
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1323:
  .quad .Laot_word_entry_1322
  .quad .Laot_word_name_1323
  .quad aot_set_fw_6964652d66696c656e616d65
.section .text
aot_get_fw_6964652d69:
  leaq reg_fw_6964652d69(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6964652d69:
  leaq reg_fw_6964652d69(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1324:
  .byte 105
  .byte 100
  .byte 101
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_1324:
  .quad .Laot_word_entry_1323
  .quad .Laot_word_name_1324
  .quad aot_get_fw_6964652d69
.section .rodata
.Laot_word_name_1325:
  .byte 58
  .byte 105
  .byte 100
  .byte 101
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_1325:
  .quad .Laot_word_entry_1324
  .quad .Laot_word_name_1325
  .quad aot_set_fw_6964652d69
.section .text
aot_get_fw_6964652d6b6579:
  leaq reg_fw_6964652d6b6579(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6964652d6b6579:
  leaq reg_fw_6964652d6b6579(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1326:
  .byte 105
  .byte 100
  .byte 101
  .byte 45
  .byte 107
  .byte 101
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_1326:
  .quad .Laot_word_entry_1325
  .quad .Laot_word_name_1326
  .quad aot_get_fw_6964652d6b6579
.section .rodata
.Laot_word_name_1327:
  .byte 58
  .byte 105
  .byte 100
  .byte 101
  .byte 45
  .byte 107
  .byte 101
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_1327:
  .quad .Laot_word_entry_1326
  .quad .Laot_word_name_1327
  .quad aot_set_fw_6964652d6b6579
.section .text
aot_get_fw_6964652d6c656e677468:
  leaq reg_fw_6964652d6c656e677468(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6964652d6c656e677468:
  leaq reg_fw_6964652d6c656e677468(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1328:
  .byte 105
  .byte 100
  .byte 101
  .byte 45
  .byte 108
  .byte 101
  .byte 110
  .byte 103
  .byte 116
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_1328:
  .quad .Laot_word_entry_1327
  .quad .Laot_word_name_1328
  .quad aot_get_fw_6964652d6c656e677468
.section .rodata
.Laot_word_name_1329:
  .byte 58
  .byte 105
  .byte 100
  .byte 101
  .byte 45
  .byte 108
  .byte 101
  .byte 110
  .byte 103
  .byte 116
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_1329:
  .quad .Laot_word_entry_1328
  .quad .Laot_word_name_1329
  .quad aot_set_fw_6964652d6c656e677468
.section .text
aot_get_fw_6964652d6e:
  leaq reg_fw_6964652d6e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6964652d6e:
  leaq reg_fw_6964652d6e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1330:
  .byte 105
  .byte 100
  .byte 101
  .byte 45
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_1330:
  .quad .Laot_word_entry_1329
  .quad .Laot_word_name_1330
  .quad aot_get_fw_6964652d6e
.section .rodata
.Laot_word_name_1331:
  .byte 58
  .byte 105
  .byte 100
  .byte 101
  .byte 45
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_1331:
  .quad .Laot_word_entry_1330
  .quad .Laot_word_name_1331
  .quad aot_set_fw_6964652d6e
.section .text
aot_get_fw_6964652d736f75726365:
  leaq reg_fw_6964652d736f75726365(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6964652d736f75726365:
  leaq reg_fw_6964652d736f75726365(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1332:
  .byte 105
  .byte 100
  .byte 101
  .byte 45
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1332:
  .quad .Laot_word_entry_1331
  .quad .Laot_word_name_1332
  .quad aot_get_fw_6964652d736f75726365
.section .rodata
.Laot_word_name_1333:
  .byte 58
  .byte 105
  .byte 100
  .byte 101
  .byte 45
  .byte 115
  .byte 111
  .byte 117
  .byte 114
  .byte 99
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1333:
  .quad .Laot_word_entry_1332
  .quad .Laot_word_name_1333
  .quad aot_set_fw_6964652d736f75726365
.section .text
aot_get_fw_6964652d74657874:
  leaq reg_fw_6964652d74657874(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6964652d74657874:
  leaq reg_fw_6964652d74657874(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1334:
  .byte 105
  .byte 100
  .byte 101
  .byte 45
  .byte 116
  .byte 101
  .byte 120
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_1334:
  .quad .Laot_word_entry_1333
  .quad .Laot_word_name_1334
  .quad aot_get_fw_6964652d74657874
.section .rodata
.Laot_word_name_1335:
  .byte 58
  .byte 105
  .byte 100
  .byte 101
  .byte 45
  .byte 116
  .byte 101
  .byte 120
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_1335:
  .quad .Laot_word_entry_1334
  .quad .Laot_word_name_1335
  .quad aot_set_fw_6964652d74657874
.section .text
aot_get_fw_70632d627573:
  leaq reg_fw_70632d627573(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_70632d627573:
  leaq reg_fw_70632d627573(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1336:
  .byte 112
  .byte 99
  .byte 45
  .byte 98
  .byte 117
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_1336:
  .quad .Laot_word_entry_1335
  .quad .Laot_word_name_1336
  .quad aot_get_fw_70632d627573
.section .rodata
.Laot_word_name_1337:
  .byte 58
  .byte 112
  .byte 99
  .byte 45
  .byte 98
  .byte 117
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_1337:
  .quad .Laot_word_entry_1336
  .quad .Laot_word_name_1337
  .quad aot_set_fw_70632d627573
.section .text
aot_get_fw_70632d646576:
  leaq reg_fw_70632d646576(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_70632d646576:
  leaq reg_fw_70632d646576(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1338:
  .byte 112
  .byte 99
  .byte 45
  .byte 100
  .byte 101
  .byte 118
  .byte 0
.section .data
.Laot_word_entry_1338:
  .quad .Laot_word_entry_1337
  .quad .Laot_word_name_1338
  .quad aot_get_fw_70632d646576
.section .rodata
.Laot_word_name_1339:
  .byte 58
  .byte 112
  .byte 99
  .byte 45
  .byte 100
  .byte 101
  .byte 118
  .byte 0
.section .data
.Laot_word_entry_1339:
  .quad .Laot_word_entry_1338
  .quad .Laot_word_name_1339
  .quad aot_set_fw_70632d646576
.section .text
aot_get_fw_70632d666e:
  leaq reg_fw_70632d666e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_70632d666e:
  leaq reg_fw_70632d666e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1340:
  .byte 112
  .byte 99
  .byte 45
  .byte 102
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_1340:
  .quad .Laot_word_entry_1339
  .quad .Laot_word_name_1340
  .quad aot_get_fw_70632d666e
.section .rodata
.Laot_word_name_1341:
  .byte 58
  .byte 112
  .byte 99
  .byte 45
  .byte 102
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_1341:
  .quad .Laot_word_entry_1340
  .quad .Laot_word_name_1341
  .quad aot_set_fw_70632d666e
.section .text
aot_get_fw_70632d6f6666:
  leaq reg_fw_70632d6f6666(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_70632d6f6666:
  leaq reg_fw_70632d6f6666(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1342:
  .byte 112
  .byte 99
  .byte 45
  .byte 111
  .byte 102
  .byte 102
  .byte 0
.section .data
.Laot_word_entry_1342:
  .quad .Laot_word_entry_1341
  .quad .Laot_word_name_1342
  .quad aot_get_fw_70632d6f6666
.section .rodata
.Laot_word_name_1343:
  .byte 58
  .byte 112
  .byte 99
  .byte 45
  .byte 111
  .byte 102
  .byte 102
  .byte 0
.section .data
.Laot_word_entry_1343:
  .quad .Laot_word_entry_1342
  .quad .Laot_word_name_1343
  .quad aot_set_fw_70632d6f6666
.section .text
aot_get_fw_70636c2d627573:
  leaq reg_fw_70636c2d627573(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_70636c2d627573:
  leaq reg_fw_70636c2d627573(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1344:
  .byte 112
  .byte 99
  .byte 108
  .byte 45
  .byte 98
  .byte 117
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_1344:
  .quad .Laot_word_entry_1343
  .quad .Laot_word_name_1344
  .quad aot_get_fw_70636c2d627573
.section .rodata
.Laot_word_name_1345:
  .byte 58
  .byte 112
  .byte 99
  .byte 108
  .byte 45
  .byte 98
  .byte 117
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_1345:
  .quad .Laot_word_entry_1344
  .quad .Laot_word_name_1345
  .quad aot_set_fw_70636c2d627573
.section .text
aot_get_fw_70636c2d646576:
  leaq reg_fw_70636c2d646576(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_70636c2d646576:
  leaq reg_fw_70636c2d646576(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1346:
  .byte 112
  .byte 99
  .byte 108
  .byte 45
  .byte 100
  .byte 101
  .byte 118
  .byte 0
.section .data
.Laot_word_entry_1346:
  .quad .Laot_word_entry_1345
  .quad .Laot_word_name_1346
  .quad aot_get_fw_70636c2d646576
.section .rodata
.Laot_word_name_1347:
  .byte 58
  .byte 112
  .byte 99
  .byte 108
  .byte 45
  .byte 100
  .byte 101
  .byte 118
  .byte 0
.section .data
.Laot_word_entry_1347:
  .quad .Laot_word_entry_1346
  .quad .Laot_word_name_1347
  .quad aot_set_fw_70636c2d646576
.section .text
aot_get_fw_70642d6964:
  leaq reg_fw_70642d6964(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_70642d6964:
  leaq reg_fw_70642d6964(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1348:
  .byte 112
  .byte 100
  .byte 45
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_1348:
  .quad .Laot_word_entry_1347
  .quad .Laot_word_name_1348
  .quad aot_get_fw_70642d6964
.section .rodata
.Laot_word_name_1349:
  .byte 58
  .byte 112
  .byte 100
  .byte 45
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_1349:
  .quad .Laot_word_entry_1348
  .quad .Laot_word_name_1349
  .quad aot_set_fw_70642d6964
.section .text
aot_get_fw_70652d6964:
  leaq reg_fw_70652d6964(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_70652d6964:
  leaq reg_fw_70652d6964(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1350:
  .byte 112
  .byte 101
  .byte 45
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_1350:
  .quad .Laot_word_entry_1349
  .quad .Laot_word_name_1350
  .quad aot_get_fw_70652d6964
.section .rodata
.Laot_word_name_1351:
  .byte 58
  .byte 112
  .byte 101
  .byte 45
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_1351:
  .quad .Laot_word_entry_1350
  .quad .Laot_word_name_1351
  .quad aot_set_fw_70652d6964
.section .text
aot_get_fw_70652d736c6f74:
  leaq reg_fw_70652d736c6f74(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_70652d736c6f74:
  leaq reg_fw_70652d736c6f74(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1352:
  .byte 112
  .byte 101
  .byte 45
  .byte 115
  .byte 108
  .byte 111
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_1352:
  .quad .Laot_word_entry_1351
  .quad .Laot_word_name_1352
  .quad aot_get_fw_70652d736c6f74
.section .rodata
.Laot_word_name_1353:
  .byte 58
  .byte 112
  .byte 101
  .byte 45
  .byte 115
  .byte 108
  .byte 111
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_1353:
  .quad .Laot_word_entry_1352
  .quad .Laot_word_name_1353
  .quad aot_set_fw_70652d736c6f74
.section .text
aot_get_fw_7069642d627573:
  leaq reg_fw_7069642d627573(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7069642d627573:
  leaq reg_fw_7069642d627573(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1354:
  .byte 112
  .byte 105
  .byte 100
  .byte 45
  .byte 98
  .byte 117
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_1354:
  .quad .Laot_word_entry_1353
  .quad .Laot_word_name_1354
  .quad aot_get_fw_7069642d627573
.section .rodata
.Laot_word_name_1355:
  .byte 58
  .byte 112
  .byte 105
  .byte 100
  .byte 45
  .byte 98
  .byte 117
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_1355:
  .quad .Laot_word_entry_1354
  .quad .Laot_word_name_1355
  .quad aot_set_fw_7069642d627573
.section .text
aot_get_fw_7069642d646576:
  leaq reg_fw_7069642d646576(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7069642d646576:
  leaq reg_fw_7069642d646576(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1356:
  .byte 112
  .byte 105
  .byte 100
  .byte 45
  .byte 100
  .byte 101
  .byte 118
  .byte 0
.section .data
.Laot_word_entry_1356:
  .quad .Laot_word_entry_1355
  .quad .Laot_word_name_1356
  .quad aot_get_fw_7069642d646576
.section .rodata
.Laot_word_name_1357:
  .byte 58
  .byte 112
  .byte 105
  .byte 100
  .byte 45
  .byte 100
  .byte 101
  .byte 118
  .byte 0
.section .data
.Laot_word_entry_1357:
  .quad .Laot_word_entry_1356
  .quad .Laot_word_name_1357
  .quad aot_set_fw_7069642d646576
.section .text
aot_get_fw_706e2d736c6f74:
  leaq reg_fw_706e2d736c6f74(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_706e2d736c6f74:
  leaq reg_fw_706e2d736c6f74(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1358:
  .byte 112
  .byte 110
  .byte 45
  .byte 115
  .byte 108
  .byte 111
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_1358:
  .quad .Laot_word_entry_1357
  .quad .Laot_word_name_1358
  .quad aot_get_fw_706e2d736c6f74
.section .rodata
.Laot_word_name_1359:
  .byte 58
  .byte 112
  .byte 110
  .byte 45
  .byte 115
  .byte 108
  .byte 111
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_1359:
  .quad .Laot_word_entry_1358
  .quad .Laot_word_name_1359
  .quad aot_set_fw_706e2d736c6f74
.section .text
aot_get_fw_70732d6964:
  leaq reg_fw_70732d6964(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_70732d6964:
  leaq reg_fw_70732d6964(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1360:
  .byte 112
  .byte 115
  .byte 45
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_1360:
  .quad .Laot_word_entry_1359
  .quad .Laot_word_name_1360
  .quad aot_get_fw_70732d6964
.section .rodata
.Laot_word_name_1361:
  .byte 58
  .byte 112
  .byte 115
  .byte 45
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_1361:
  .quad .Laot_word_entry_1360
  .quad .Laot_word_name_1361
  .quad aot_set_fw_70732d6964
.section .text
aot_get_fw_70732d736c6f74:
  leaq reg_fw_70732d736c6f74(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_70732d736c6f74:
  leaq reg_fw_70732d736c6f74(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1362:
  .byte 112
  .byte 115
  .byte 45
  .byte 115
  .byte 108
  .byte 111
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_1362:
  .quad .Laot_word_entry_1361
  .quad .Laot_word_name_1362
  .quad aot_get_fw_70732d736c6f74
.section .rodata
.Laot_word_name_1363:
  .byte 58
  .byte 112
  .byte 115
  .byte 45
  .byte 115
  .byte 108
  .byte 111
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_1363:
  .quad .Laot_word_entry_1362
  .quad .Laot_word_name_1363
  .quad aot_set_fw_70732d736c6f74
.section .text
aot_get_fw_70762d6964:
  leaq reg_fw_70762d6964(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_70762d6964:
  leaq reg_fw_70762d6964(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1364:
  .byte 112
  .byte 118
  .byte 45
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_1364:
  .quad .Laot_word_entry_1363
  .quad .Laot_word_name_1364
  .quad aot_get_fw_70762d6964
.section .rodata
.Laot_word_name_1365:
  .byte 58
  .byte 112
  .byte 118
  .byte 45
  .byte 105
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_1365:
  .quad .Laot_word_entry_1364
  .quad .Laot_word_name_1365
  .quad aot_set_fw_70762d6964
.section .text
aot_get_fw_7461736b2d61:
  leaq reg_fw_7461736b2d61(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7461736b2d61:
  leaq reg_fw_7461736b2d61(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1366:
  .byte 116
  .byte 97
  .byte 115
  .byte 107
  .byte 45
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_1366:
  .quad .Laot_word_entry_1365
  .quad .Laot_word_name_1366
  .quad aot_get_fw_7461736b2d61
.section .rodata
.Laot_word_name_1367:
  .byte 58
  .byte 116
  .byte 97
  .byte 115
  .byte 107
  .byte 45
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_1367:
  .quad .Laot_word_entry_1366
  .quad .Laot_word_name_1367
  .quad aot_set_fw_7461736b2d61
.section .text
aot_get_fw_7461736b2d62:
  leaq reg_fw_7461736b2d62(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7461736b2d62:
  leaq reg_fw_7461736b2d62(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1368:
  .byte 116
  .byte 97
  .byte 115
  .byte 107
  .byte 45
  .byte 98
  .byte 0
.section .data
.Laot_word_entry_1368:
  .quad .Laot_word_entry_1367
  .quad .Laot_word_name_1368
  .quad aot_get_fw_7461736b2d62
.section .rodata
.Laot_word_name_1369:
  .byte 58
  .byte 116
  .byte 97
  .byte 115
  .byte 107
  .byte 45
  .byte 98
  .byte 0
.section .data
.Laot_word_entry_1369:
  .quad .Laot_word_entry_1368
  .quad .Laot_word_name_1369
  .quad aot_set_fw_7461736b2d62
.section .text
aot_get_fw_7461736b2d636f756e74:
  leaq reg_fw_7461736b2d636f756e74(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7461736b2d636f756e74:
  leaq reg_fw_7461736b2d636f756e74(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1370:
  .byte 116
  .byte 97
  .byte 115
  .byte 107
  .byte 45
  .byte 99
  .byte 111
  .byte 117
  .byte 110
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_1370:
  .quad .Laot_word_entry_1369
  .quad .Laot_word_name_1370
  .quad aot_get_fw_7461736b2d636f756e74
.section .rodata
.Laot_word_name_1371:
  .byte 58
  .byte 116
  .byte 97
  .byte 115
  .byte 107
  .byte 45
  .byte 99
  .byte 111
  .byte 117
  .byte 110
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_1371:
  .quad .Laot_word_entry_1370
  .quad .Laot_word_name_1371
  .quad aot_set_fw_7461736b2d636f756e74
.section .text
aot_get_fw_7461736b2d646f6e65:
  leaq reg_fw_7461736b2d646f6e65(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7461736b2d646f6e65:
  leaq reg_fw_7461736b2d646f6e65(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1372:
  .byte 116
  .byte 97
  .byte 115
  .byte 107
  .byte 45
  .byte 100
  .byte 111
  .byte 110
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1372:
  .quad .Laot_word_entry_1371
  .quad .Laot_word_name_1372
  .quad aot_get_fw_7461736b2d646f6e65
.section .rodata
.Laot_word_name_1373:
  .byte 58
  .byte 116
  .byte 97
  .byte 115
  .byte 107
  .byte 45
  .byte 100
  .byte 111
  .byte 110
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1373:
  .quad .Laot_word_entry_1372
  .quad .Laot_word_name_1373
  .quad aot_set_fw_7461736b2d646f6e65
.section .text
aot_get_fw_7461736b2d656e747279:
  leaq reg_fw_7461736b2d656e747279(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7461736b2d656e747279:
  leaq reg_fw_7461736b2d656e747279(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1374:
  .byte 116
  .byte 97
  .byte 115
  .byte 107
  .byte 45
  .byte 101
  .byte 110
  .byte 116
  .byte 114
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_1374:
  .quad .Laot_word_entry_1373
  .quad .Laot_word_name_1374
  .quad aot_get_fw_7461736b2d656e747279
.section .rodata
.Laot_word_name_1375:
  .byte 58
  .byte 116
  .byte 97
  .byte 115
  .byte 107
  .byte 45
  .byte 101
  .byte 110
  .byte 116
  .byte 114
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_1375:
  .quad .Laot_word_entry_1374
  .quad .Laot_word_name_1375
  .quad aot_set_fw_7461736b2d656e747279
.section .text
aot_get_fw_7461736b2d7374657073:
  leaq reg_fw_7461736b2d7374657073(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7461736b2d7374657073:
  leaq reg_fw_7461736b2d7374657073(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1376:
  .byte 116
  .byte 97
  .byte 115
  .byte 107
  .byte 45
  .byte 115
  .byte 116
  .byte 101
  .byte 112
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_1376:
  .quad .Laot_word_entry_1375
  .quad .Laot_word_name_1376
  .quad aot_get_fw_7461736b2d7374657073
.section .rodata
.Laot_word_name_1377:
  .byte 58
  .byte 116
  .byte 97
  .byte 115
  .byte 107
  .byte 45
  .byte 115
  .byte 116
  .byte 101
  .byte 112
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_1377:
  .quad .Laot_word_entry_1376
  .quad .Laot_word_name_1377
  .quad aot_set_fw_7461736b2d7374657073
.section .text
aot_get_fw_7461736b2d7469636b73:
  leaq reg_fw_7461736b2d7469636b73(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7461736b2d7469636b73:
  leaq reg_fw_7461736b2d7469636b73(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1378:
  .byte 116
  .byte 97
  .byte 115
  .byte 107
  .byte 45
  .byte 116
  .byte 105
  .byte 99
  .byte 107
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_1378:
  .quad .Laot_word_entry_1377
  .quad .Laot_word_name_1378
  .quad aot_get_fw_7461736b2d7469636b73
.section .rodata
.Laot_word_name_1379:
  .byte 58
  .byte 116
  .byte 97
  .byte 115
  .byte 107
  .byte 45
  .byte 116
  .byte 105
  .byte 99
  .byte 107
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_1379:
  .quad .Laot_word_entry_1378
  .quad .Laot_word_name_1379
  .quad aot_set_fw_7461736b2d7469636b73
.section .text
aot_get_fw_7461736b2d7475726e:
  leaq reg_fw_7461736b2d7475726e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_7461736b2d7475726e:
  leaq reg_fw_7461736b2d7475726e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1380:
  .byte 116
  .byte 97
  .byte 115
  .byte 107
  .byte 45
  .byte 116
  .byte 117
  .byte 114
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_1380:
  .quad .Laot_word_entry_1379
  .quad .Laot_word_name_1380
  .quad aot_get_fw_7461736b2d7475726e
.section .rodata
.Laot_word_name_1381:
  .byte 58
  .byte 116
  .byte 97
  .byte 115
  .byte 107
  .byte 45
  .byte 116
  .byte 117
  .byte 114
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_1381:
  .quad .Laot_word_entry_1380
  .quad .Laot_word_name_1381
  .quad aot_set_fw_7461736b2d7475726e
.section .text
aot_get_fw_6e65742d616374697665:
  leaq reg_fw_6e65742d616374697665(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6e65742d616374697665:
  leaq reg_fw_6e65742d616374697665(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1382:
  .byte 110
  .byte 101
  .byte 116
  .byte 45
  .byte 97
  .byte 99
  .byte 116
  .byte 105
  .byte 118
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1382:
  .quad .Laot_word_entry_1381
  .quad .Laot_word_name_1382
  .quad aot_get_fw_6e65742d616374697665
.section .rodata
.Laot_word_name_1383:
  .byte 58
  .byte 110
  .byte 101
  .byte 116
  .byte 45
  .byte 97
  .byte 99
  .byte 116
  .byte 105
  .byte 118
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1383:
  .quad .Laot_word_entry_1382
  .quad .Laot_word_name_1383
  .quad aot_set_fw_6e65742d616374697665
.section .text
aot_get_fw_6e65742d626172:
  leaq reg_fw_6e65742d626172(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6e65742d626172:
  leaq reg_fw_6e65742d626172(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1384:
  .byte 110
  .byte 101
  .byte 116
  .byte 45
  .byte 98
  .byte 97
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_1384:
  .quad .Laot_word_entry_1383
  .quad .Laot_word_name_1384
  .quad aot_get_fw_6e65742d626172
.section .rodata
.Laot_word_name_1385:
  .byte 58
  .byte 110
  .byte 101
  .byte 116
  .byte 45
  .byte 98
  .byte 97
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_1385:
  .quad .Laot_word_entry_1384
  .quad .Laot_word_name_1385
  .quad aot_set_fw_6e65742d626172
.section .text
aot_get_fw_6e65742d69:
  leaq reg_fw_6e65742d69(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6e65742d69:
  leaq reg_fw_6e65742d69(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1386:
  .byte 110
  .byte 101
  .byte 116
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_1386:
  .quad .Laot_word_entry_1385
  .quad .Laot_word_name_1386
  .quad aot_get_fw_6e65742d69
.section .rodata
.Laot_word_name_1387:
  .byte 58
  .byte 110
  .byte 101
  .byte 116
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_1387:
  .quad .Laot_word_entry_1386
  .quad .Laot_word_name_1387
  .quad aot_set_fw_6e65742d69
.section .text
aot_get_fw_6e65742d696f62617365:
  leaq reg_fw_6e65742d696f62617365(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6e65742d696f62617365:
  leaq reg_fw_6e65742d696f62617365(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1388:
  .byte 110
  .byte 101
  .byte 116
  .byte 45
  .byte 105
  .byte 111
  .byte 98
  .byte 97
  .byte 115
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1388:
  .quad .Laot_word_entry_1387
  .quad .Laot_word_name_1388
  .quad aot_get_fw_6e65742d696f62617365
.section .rodata
.Laot_word_name_1389:
  .byte 58
  .byte 110
  .byte 101
  .byte 116
  .byte 45
  .byte 105
  .byte 111
  .byte 98
  .byte 97
  .byte 115
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1389:
  .quad .Laot_word_entry_1388
  .quad .Laot_word_name_1389
  .quad aot_set_fw_6e65742d696f62617365
.section .text
aot_get_fw_6e65742d6d6d696f:
  leaq reg_fw_6e65742d6d6d696f(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6e65742d6d6d696f:
  leaq reg_fw_6e65742d6d6d696f(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1390:
  .byte 110
  .byte 101
  .byte 116
  .byte 45
  .byte 109
  .byte 109
  .byte 105
  .byte 111
  .byte 0
.section .data
.Laot_word_entry_1390:
  .quad .Laot_word_entry_1389
  .quad .Laot_word_name_1390
  .quad aot_get_fw_6e65742d6d6d696f
.section .rodata
.Laot_word_name_1391:
  .byte 58
  .byte 110
  .byte 101
  .byte 116
  .byte 45
  .byte 109
  .byte 109
  .byte 105
  .byte 111
  .byte 0
.section .data
.Laot_word_entry_1391:
  .quad .Laot_word_entry_1390
  .quad .Laot_word_name_1391
  .quad aot_set_fw_6e65742d6d6d696f
.section .text
aot_get_fw_6e65742d6a:
  leaq reg_fw_6e65742d6a(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6e65742d6a:
  leaq reg_fw_6e65742d6a(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1392:
  .byte 110
  .byte 101
  .byte 116
  .byte 45
  .byte 106
  .byte 0
.section .data
.Laot_word_entry_1392:
  .quad .Laot_word_entry_1391
  .quad .Laot_word_name_1392
  .quad aot_get_fw_6e65742d6a
.section .rodata
.Laot_word_name_1393:
  .byte 58
  .byte 110
  .byte 101
  .byte 116
  .byte 45
  .byte 106
  .byte 0
.section .data
.Laot_word_entry_1393:
  .quad .Laot_word_entry_1392
  .quad .Laot_word_name_1393
  .quad aot_set_fw_6e65742d6a
.section .text
aot_get_fw_6e65742d6c656e:
  leaq reg_fw_6e65742d6c656e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6e65742d6c656e:
  leaq reg_fw_6e65742d6c656e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1394:
  .byte 110
  .byte 101
  .byte 116
  .byte 45
  .byte 108
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_1394:
  .quad .Laot_word_entry_1393
  .quad .Laot_word_name_1394
  .quad aot_get_fw_6e65742d6c656e
.section .rodata
.Laot_word_name_1395:
  .byte 58
  .byte 110
  .byte 101
  .byte 116
  .byte 45
  .byte 108
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_1395:
  .quad .Laot_word_entry_1394
  .quad .Laot_word_name_1395
  .quad aot_set_fw_6e65742d6c656e
.section .text
aot_get_fw_6e65742d6d61636869:
  leaq reg_fw_6e65742d6d61636869(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6e65742d6d61636869:
  leaq reg_fw_6e65742d6d61636869(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1396:
  .byte 110
  .byte 101
  .byte 116
  .byte 45
  .byte 109
  .byte 97
  .byte 99
  .byte 104
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_1396:
  .quad .Laot_word_entry_1395
  .quad .Laot_word_name_1396
  .quad aot_get_fw_6e65742d6d61636869
.section .rodata
.Laot_word_name_1397:
  .byte 58
  .byte 110
  .byte 101
  .byte 116
  .byte 45
  .byte 109
  .byte 97
  .byte 99
  .byte 104
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_1397:
  .quad .Laot_word_entry_1396
  .quad .Laot_word_name_1397
  .quad aot_set_fw_6e65742d6d61636869
.section .text
aot_get_fw_6e65742d6d61636c6f:
  leaq reg_fw_6e65742d6d61636c6f(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6e65742d6d61636c6f:
  leaq reg_fw_6e65742d6d61636c6f(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1398:
  .byte 110
  .byte 101
  .byte 116
  .byte 45
  .byte 109
  .byte 97
  .byte 99
  .byte 108
  .byte 111
  .byte 0
.section .data
.Laot_word_entry_1398:
  .quad .Laot_word_entry_1397
  .quad .Laot_word_name_1398
  .quad aot_get_fw_6e65742d6d61636c6f
.section .rodata
.Laot_word_name_1399:
  .byte 58
  .byte 110
  .byte 101
  .byte 116
  .byte 45
  .byte 109
  .byte 97
  .byte 99
  .byte 108
  .byte 111
  .byte 0
.section .data
.Laot_word_entry_1399:
  .quad .Laot_word_entry_1398
  .quad .Laot_word_name_1399
  .quad aot_set_fw_6e65742d6d61636c6f
.section .text
aot_get_fw_6e65742d6f6374:
  leaq reg_fw_6e65742d6f6374(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6e65742d6f6374:
  leaq reg_fw_6e65742d6f6374(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1400:
  .byte 110
  .byte 101
  .byte 116
  .byte 45
  .byte 111
  .byte 99
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_1400:
  .quad .Laot_word_entry_1399
  .quad .Laot_word_name_1400
  .quad aot_get_fw_6e65742d6f6374
.section .rodata
.Laot_word_name_1401:
  .byte 58
  .byte 110
  .byte 101
  .byte 116
  .byte 45
  .byte 111
  .byte 99
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_1401:
  .quad .Laot_word_entry_1400
  .quad .Laot_word_name_1401
  .quad aot_set_fw_6e65742d6f6374
.section .text
aot_get_fw_6e65742d706369636d64:
  leaq reg_fw_6e65742d706369636d64(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6e65742d706369636d64:
  leaq reg_fw_6e65742d706369636d64(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1402:
  .byte 110
  .byte 101
  .byte 116
  .byte 45
  .byte 112
  .byte 99
  .byte 105
  .byte 99
  .byte 109
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_1402:
  .quad .Laot_word_entry_1401
  .quad .Laot_word_name_1402
  .quad aot_get_fw_6e65742d706369636d64
.section .rodata
.Laot_word_name_1403:
  .byte 58
  .byte 110
  .byte 101
  .byte 116
  .byte 45
  .byte 112
  .byte 99
  .byte 105
  .byte 99
  .byte 109
  .byte 100
  .byte 0
.section .data
.Laot_word_entry_1403:
  .quad .Laot_word_entry_1402
  .quad .Laot_word_name_1403
  .quad aot_set_fw_6e65742d706369636d64
.section .text
aot_get_fw_6e65742d707472:
  leaq reg_fw_6e65742d707472(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6e65742d707472:
  leaq reg_fw_6e65742d707472(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1404:
  .byte 110
  .byte 101
  .byte 116
  .byte 45
  .byte 112
  .byte 116
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_1404:
  .quad .Laot_word_entry_1403
  .quad .Laot_word_name_1404
  .quad aot_get_fw_6e65742d707472
.section .rodata
.Laot_word_name_1405:
  .byte 58
  .byte 110
  .byte 101
  .byte 116
  .byte 45
  .byte 112
  .byte 116
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_1405:
  .quad .Laot_word_entry_1404
  .quad .Laot_word_name_1405
  .quad aot_set_fw_6e65742d707472
.section .text
aot_get_fw_6e65742d726567:
  leaq reg_fw_6e65742d726567(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6e65742d726567:
  leaq reg_fw_6e65742d726567(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1406:
  .byte 110
  .byte 101
  .byte 116
  .byte 45
  .byte 114
  .byte 101
  .byte 103
  .byte 0
.section .data
.Laot_word_entry_1406:
  .quad .Laot_word_entry_1405
  .quad .Laot_word_name_1406
  .quad aot_get_fw_6e65742d726567
.section .rodata
.Laot_word_name_1407:
  .byte 58
  .byte 110
  .byte 101
  .byte 116
  .byte 45
  .byte 114
  .byte 101
  .byte 103
  .byte 0
.section .data
.Laot_word_entry_1407:
  .quad .Laot_word_entry_1406
  .quad .Laot_word_name_1407
  .quad aot_set_fw_6e65742d726567
.section .text
aot_get_fw_6e65742d73656e74:
  leaq reg_fw_6e65742d73656e74(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6e65742d73656e74:
  leaq reg_fw_6e65742d73656e74(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1408:
  .byte 110
  .byte 101
  .byte 116
  .byte 45
  .byte 115
  .byte 101
  .byte 110
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_1408:
  .quad .Laot_word_entry_1407
  .quad .Laot_word_name_1408
  .quad aot_get_fw_6e65742d73656e74
.section .rodata
.Laot_word_name_1409:
  .byte 58
  .byte 110
  .byte 101
  .byte 116
  .byte 45
  .byte 115
  .byte 101
  .byte 110
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_1409:
  .quad .Laot_word_entry_1408
  .quad .Laot_word_name_1409
  .quad aot_set_fw_6e65742d73656e74
.section .text
aot_get_fw_6e65742d73697a65:
  leaq reg_fw_6e65742d73697a65(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6e65742d73697a65:
  leaq reg_fw_6e65742d73697a65(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1410:
  .byte 110
  .byte 101
  .byte 116
  .byte 45
  .byte 115
  .byte 105
  .byte 122
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1410:
  .quad .Laot_word_entry_1409
  .quad .Laot_word_name_1410
  .quad aot_get_fw_6e65742d73697a65
.section .rodata
.Laot_word_name_1411:
  .byte 58
  .byte 110
  .byte 101
  .byte 116
  .byte 45
  .byte 115
  .byte 105
  .byte 122
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1411:
  .quad .Laot_word_entry_1410
  .quad .Laot_word_name_1411
  .quad aot_set_fw_6e65742d73697a65
.section .text
aot_get_fw_6e65742d736c6f74:
  leaq reg_fw_6e65742d736c6f74(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6e65742d736c6f74:
  leaq reg_fw_6e65742d736c6f74(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1412:
  .byte 110
  .byte 101
  .byte 116
  .byte 45
  .byte 115
  .byte 108
  .byte 111
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_1412:
  .quad .Laot_word_entry_1411
  .quad .Laot_word_name_1412
  .quad aot_get_fw_6e65742d736c6f74
.section .rodata
.Laot_word_name_1413:
  .byte 58
  .byte 110
  .byte 101
  .byte 116
  .byte 45
  .byte 115
  .byte 108
  .byte 111
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_1413:
  .quad .Laot_word_entry_1412
  .quad .Laot_word_name_1413
  .quad aot_set_fw_6e65742d736c6f74
.section .text
aot_get_fw_6e65742d737263:
  leaq reg_fw_6e65742d737263(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6e65742d737263:
  leaq reg_fw_6e65742d737263(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1414:
  .byte 110
  .byte 101
  .byte 116
  .byte 45
  .byte 115
  .byte 114
  .byte 99
  .byte 0
.section .data
.Laot_word_entry_1414:
  .quad .Laot_word_entry_1413
  .quad .Laot_word_name_1414
  .quad aot_get_fw_6e65742d737263
.section .rodata
.Laot_word_name_1415:
  .byte 58
  .byte 110
  .byte 101
  .byte 116
  .byte 45
  .byte 115
  .byte 114
  .byte 99
  .byte 0
.section .data
.Laot_word_entry_1415:
  .quad .Laot_word_entry_1414
  .quad .Laot_word_name_1415
  .quad aot_set_fw_6e65742d737263
.section .text
aot_get_fw_6e65742d76616c7565:
  leaq reg_fw_6e65742d76616c7565(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6e65742d76616c7565:
  leaq reg_fw_6e65742d76616c7565(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1416:
  .byte 110
  .byte 101
  .byte 116
  .byte 45
  .byte 118
  .byte 97
  .byte 108
  .byte 117
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1416:
  .quad .Laot_word_entry_1415
  .quad .Laot_word_name_1416
  .quad aot_get_fw_6e65742d76616c7565
.section .rodata
.Laot_word_name_1417:
  .byte 58
  .byte 110
  .byte 101
  .byte 116
  .byte 45
  .byte 118
  .byte 97
  .byte 108
  .byte 117
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1417:
  .quad .Laot_word_entry_1416
  .quad .Laot_word_name_1417
  .quad aot_set_fw_6e65742d76616c7565
.section .text
aot_get_fw_6669622d61:
  leaq reg_fw_6669622d61(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6669622d61:
  leaq reg_fw_6669622d61(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1418:
  .byte 102
  .byte 105
  .byte 98
  .byte 45
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_1418:
  .quad .Laot_word_entry_1417
  .quad .Laot_word_name_1418
  .quad aot_get_fw_6669622d61
.section .rodata
.Laot_word_name_1419:
  .byte 58
  .byte 102
  .byte 105
  .byte 98
  .byte 45
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_1419:
  .quad .Laot_word_entry_1418
  .quad .Laot_word_name_1419
  .quad aot_set_fw_6669622d61
.section .text
aot_get_fw_6669622d62:
  leaq reg_fw_6669622d62(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6669622d62:
  leaq reg_fw_6669622d62(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1420:
  .byte 102
  .byte 105
  .byte 98
  .byte 45
  .byte 98
  .byte 0
.section .data
.Laot_word_entry_1420:
  .quad .Laot_word_entry_1419
  .quad .Laot_word_name_1420
  .quad aot_get_fw_6669622d62
.section .rodata
.Laot_word_name_1421:
  .byte 58
  .byte 102
  .byte 105
  .byte 98
  .byte 45
  .byte 98
  .byte 0
.section .data
.Laot_word_entry_1421:
  .quad .Laot_word_entry_1420
  .quad .Laot_word_name_1421
  .quad aot_set_fw_6669622d62
.section .text
aot_get_fw_6669622d6e:
  leaq reg_fw_6669622d6e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6669622d6e:
  leaq reg_fw_6669622d6e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1422:
  .byte 102
  .byte 105
  .byte 98
  .byte 45
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_1422:
  .quad .Laot_word_entry_1421
  .quad .Laot_word_name_1422
  .quad aot_get_fw_6669622d6e
.section .rodata
.Laot_word_name_1423:
  .byte 58
  .byte 102
  .byte 105
  .byte 98
  .byte 45
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_1423:
  .quad .Laot_word_entry_1422
  .quad .Laot_word_name_1423
  .quad aot_set_fw_6669622d6e
.section .text
aot_get_fw_6669622d69:
  leaq reg_fw_6669622d69(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_6669622d69:
  leaq reg_fw_6669622d69(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1424:
  .byte 102
  .byte 105
  .byte 98
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_1424:
  .quad .Laot_word_entry_1423
  .quad .Laot_word_name_1424
  .quad aot_get_fw_6669622d69
.section .rodata
.Laot_word_name_1425:
  .byte 58
  .byte 102
  .byte 105
  .byte 98
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_1425:
  .quad .Laot_word_entry_1424
  .quad .Laot_word_name_1425
  .quad aot_set_fw_6669622d69
.section .text
aot_get_fw_66742d6174:
  leaq reg_fw_66742d6174(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_66742d6174:
  leaq reg_fw_66742d6174(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1426:
  .byte 102
  .byte 116
  .byte 45
  .byte 97
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_1426:
  .quad .Laot_word_entry_1425
  .quad .Laot_word_name_1426
  .quad aot_get_fw_66742d6174
.section .rodata
.Laot_word_name_1427:
  .byte 58
  .byte 102
  .byte 116
  .byte 45
  .byte 97
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_1427:
  .quad .Laot_word_entry_1426
  .quad .Laot_word_name_1427
  .quad aot_set_fw_66742d6174
.section .text
aot_get_fw_66742d6368:
  leaq reg_fw_66742d6368(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_66742d6368:
  leaq reg_fw_66742d6368(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1428:
  .byte 102
  .byte 116
  .byte 45
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_1428:
  .quad .Laot_word_entry_1427
  .quad .Laot_word_name_1428
  .quad aot_get_fw_66742d6368
.section .rodata
.Laot_word_name_1429:
  .byte 58
  .byte 102
  .byte 116
  .byte 45
  .byte 99
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_1429:
  .quad .Laot_word_entry_1428
  .quad .Laot_word_name_1429
  .quad aot_set_fw_66742d6368
.section .text
aot_get_fw_66742d64617461:
  leaq reg_fw_66742d64617461(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_66742d64617461:
  leaq reg_fw_66742d64617461(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1430:
  .byte 102
  .byte 116
  .byte 45
  .byte 100
  .byte 97
  .byte 116
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_1430:
  .quad .Laot_word_entry_1429
  .quad .Laot_word_name_1430
  .quad aot_get_fw_66742d64617461
.section .rodata
.Laot_word_name_1431:
  .byte 58
  .byte 102
  .byte 116
  .byte 45
  .byte 100
  .byte 97
  .byte 116
  .byte 97
  .byte 0
.section .data
.Laot_word_entry_1431:
  .quad .Laot_word_entry_1430
  .quad .Laot_word_name_1431
  .quad aot_set_fw_66742d64617461
.section .text
aot_get_fw_66742d64656e:
  leaq reg_fw_66742d64656e(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_66742d64656e:
  leaq reg_fw_66742d64656e(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1432:
  .byte 102
  .byte 116
  .byte 45
  .byte 100
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_1432:
  .quad .Laot_word_entry_1431
  .quad .Laot_word_name_1432
  .quad aot_get_fw_66742d64656e
.section .rodata
.Laot_word_name_1433:
  .byte 58
  .byte 102
  .byte 116
  .byte 45
  .byte 100
  .byte 101
  .byte 110
  .byte 0
.section .data
.Laot_word_entry_1433:
  .quad .Laot_word_entry_1432
  .quad .Laot_word_name_1433
  .quad aot_set_fw_66742d64656e
.section .text
aot_get_fw_66742d69:
  leaq reg_fw_66742d69(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_66742d69:
  leaq reg_fw_66742d69(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1434:
  .byte 102
  .byte 116
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_1434:
  .quad .Laot_word_entry_1433
  .quad .Laot_word_name_1434
  .quad aot_get_fw_66742d69
.section .rodata
.Laot_word_name_1435:
  .byte 58
  .byte 102
  .byte 116
  .byte 45
  .byte 105
  .byte 0
.section .data
.Laot_word_entry_1435:
  .quad .Laot_word_entry_1434
  .quad .Laot_word_name_1435
  .quad aot_set_fw_66742d69
.section .text
aot_get_fw_66742d6e616d65:
  leaq reg_fw_66742d6e616d65(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_66742d6e616d65:
  leaq reg_fw_66742d6e616d65(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1436:
  .byte 102
  .byte 116
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1436:
  .quad .Laot_word_entry_1435
  .quad .Laot_word_name_1436
  .quad aot_get_fw_66742d6e616d65
.section .rodata
.Laot_word_name_1437:
  .byte 58
  .byte 102
  .byte 116
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1437:
  .quad .Laot_word_entry_1436
  .quad .Laot_word_name_1437
  .quad aot_set_fw_66742d6e616d65
.section .text
aot_get_fw_66742d6e616d652d6c656e677468:
  leaq reg_fw_66742d6e616d652d6c656e677468(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_66742d6e616d652d6c656e677468:
  leaq reg_fw_66742d6e616d652d6c656e677468(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1438:
  .byte 102
  .byte 116
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 45
  .byte 108
  .byte 101
  .byte 110
  .byte 103
  .byte 116
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_1438:
  .quad .Laot_word_entry_1437
  .quad .Laot_word_name_1438
  .quad aot_get_fw_66742d6e616d652d6c656e677468
.section .rodata
.Laot_word_name_1439:
  .byte 58
  .byte 102
  .byte 116
  .byte 45
  .byte 110
  .byte 97
  .byte 109
  .byte 101
  .byte 45
  .byte 108
  .byte 101
  .byte 110
  .byte 103
  .byte 116
  .byte 104
  .byte 0
.section .data
.Laot_word_entry_1439:
  .quad .Laot_word_entry_1438
  .quad .Laot_word_name_1439
  .quad aot_set_fw_66742d6e616d652d6c656e677468
.section .text
aot_get_fw_66742d6e756d:
  leaq reg_fw_66742d6e756d(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_66742d6e756d:
  leaq reg_fw_66742d6e756d(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1440:
  .byte 102
  .byte 116
  .byte 45
  .byte 110
  .byte 117
  .byte 109
  .byte 0
.section .data
.Laot_word_entry_1440:
  .quad .Laot_word_entry_1439
  .quad .Laot_word_name_1440
  .quad aot_get_fw_66742d6e756d
.section .rodata
.Laot_word_name_1441:
  .byte 58
  .byte 102
  .byte 116
  .byte 45
  .byte 110
  .byte 117
  .byte 109
  .byte 0
.section .data
.Laot_word_entry_1441:
  .quad .Laot_word_entry_1440
  .quad .Laot_word_name_1441
  .quad aot_set_fw_66742d6e756d
.section .text
aot_get_fw_66742d6f6b:
  leaq reg_fw_66742d6f6b(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_66742d6f6b:
  leaq reg_fw_66742d6f6b(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1442:
  .byte 102
  .byte 116
  .byte 45
  .byte 111
  .byte 107
  .byte 0
.section .data
.Laot_word_entry_1442:
  .quad .Laot_word_entry_1441
  .quad .Laot_word_name_1442
  .quad aot_get_fw_66742d6f6b
.section .rodata
.Laot_word_name_1443:
  .byte 58
  .byte 102
  .byte 116
  .byte 45
  .byte 111
  .byte 107
  .byte 0
.section .data
.Laot_word_entry_1443:
  .quad .Laot_word_entry_1442
  .quad .Laot_word_name_1443
  .quad aot_set_fw_66742d6f6b
.section .text
aot_get_fw_66742d73697a65:
  leaq reg_fw_66742d73697a65(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_66742d73697a65:
  leaq reg_fw_66742d73697a65(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1444:
  .byte 102
  .byte 116
  .byte 45
  .byte 115
  .byte 105
  .byte 122
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1444:
  .quad .Laot_word_entry_1443
  .quad .Laot_word_name_1444
  .quad aot_get_fw_66742d73697a65
.section .rodata
.Laot_word_name_1445:
  .byte 58
  .byte 102
  .byte 116
  .byte 45
  .byte 115
  .byte 105
  .byte 122
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1445:
  .quad .Laot_word_entry_1444
  .quad .Laot_word_name_1445
  .quad aot_set_fw_66742d73697a65
.section .text
aot_get_fw_66742d7374657073:
  leaq reg_fw_66742d7374657073(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_66742d7374657073:
  leaq reg_fw_66742d7374657073(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1446:
  .byte 102
  .byte 116
  .byte 45
  .byte 115
  .byte 116
  .byte 101
  .byte 112
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_1446:
  .quad .Laot_word_entry_1445
  .quad .Laot_word_name_1446
  .quad aot_get_fw_66742d7374657073
.section .rodata
.Laot_word_name_1447:
  .byte 58
  .byte 102
  .byte 116
  .byte 45
  .byte 115
  .byte 116
  .byte 101
  .byte 112
  .byte 115
  .byte 0
.section .data
.Laot_word_entry_1447:
  .quad .Laot_word_entry_1446
  .quad .Laot_word_name_1447
  .quad aot_set_fw_66742d7374657073
.section .text
aot_get_fw_66742d76616c7565:
  leaq reg_fw_66742d76616c7565(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_66742d76616c7565:
  leaq reg_fw_66742d76616c7565(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1448:
  .byte 102
  .byte 116
  .byte 45
  .byte 118
  .byte 97
  .byte 108
  .byte 117
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1448:
  .quad .Laot_word_entry_1447
  .quad .Laot_word_name_1448
  .quad aot_get_fw_66742d76616c7565
.section .rodata
.Laot_word_name_1449:
  .byte 58
  .byte 102
  .byte 116
  .byte 45
  .byte 118
  .byte 97
  .byte 108
  .byte 117
  .byte 101
  .byte 0
.section .data
.Laot_word_entry_1449:
  .quad .Laot_word_entry_1448
  .quad .Laot_word_name_1449
  .quad aot_set_fw_66742d76616c7565
.section .text
aot_get_fw_636f756e74:
  leaq reg_fw_636f756e74(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_636f756e74:
  leaq reg_fw_636f756e74(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1450:
  .byte 99
  .byte 111
  .byte 117
  .byte 110
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_1450:
  .quad .Laot_word_entry_1449
  .quad .Laot_word_name_1450
  .quad aot_get_fw_636f756e74
.section .rodata
.Laot_word_name_1451:
  .byte 58
  .byte 99
  .byte 111
  .byte 117
  .byte 110
  .byte 116
  .byte 0
.section .data
.Laot_word_entry_1451:
  .quad .Laot_word_entry_1450
  .quad .Laot_word_name_1451
  .quad aot_set_fw_636f756e74
.section .text
aot_get_fw_73632d707472:
  leaq reg_fw_73632d707472(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_73632d707472:
  leaq reg_fw_73632d707472(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1452:
  .byte 115
  .byte 99
  .byte 45
  .byte 112
  .byte 116
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_1452:
  .quad .Laot_word_entry_1451
  .quad .Laot_word_name_1452
  .quad aot_get_fw_73632d707472
.section .rodata
.Laot_word_name_1453:
  .byte 58
  .byte 115
  .byte 99
  .byte 45
  .byte 112
  .byte 116
  .byte 114
  .byte 0
.section .data
.Laot_word_entry_1453:
  .quad .Laot_word_entry_1452
  .quad .Laot_word_name_1453
  .quad aot_set_fw_73632d707472
.section .text
aot_get_fw_63632d6b6579:
  leaq reg_fw_63632d6b6579(%rip), %rdi
  jmp fr_reg_get
aot_set_fw_63632d6b6579:
  leaq reg_fw_63632d6b6579(%rip), %rdi
  jmp fr_reg_set
.section .rodata
.Laot_word_name_1454:
  .byte 99
  .byte 99
  .byte 45
  .byte 107
  .byte 101
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_1454:
  .quad .Laot_word_entry_1453
  .quad .Laot_word_name_1454
  .quad aot_get_fw_63632d6b6579
.section .rodata
.Laot_word_name_1455:
  .byte 58
  .byte 99
  .byte 99
  .byte 45
  .byte 107
  .byte 101
  .byte 121
  .byte 0
.section .data
.Laot_word_entry_1455:
  .quad .Laot_word_entry_1454
  .quad .Laot_word_name_1455
  .quad aot_set_fw_63632d6b6579
.section .data
.global franc_dict_initial
franc_dict_initial:
  .quad .Laot_word_entry_1455
.section .rodata
.global franc_stage2_source
franc_stage2_source:
  .incbin "stage2/compiler.frac"
  .byte 0
