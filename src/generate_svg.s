.section .rodata
.include "src/elements.inc"
.include "src/categories.inc"

// Layout Constants
.equ SVG_WIDTH,      1150
.equ SVG_HEIGHT,     820
.equ CELL_WIDTH,     56
.equ CELL_HEIGHT,    70
.equ GAP,            4
.equ CELL_STEP_X,    60 // CELL_WIDTH + GAP
.equ CELL_STEP_Y,    74 // CELL_HEIGHT + GAP
.equ OFFSET_X,       40
.equ OFFSET_Y,       40
.equ BLOCK_GAP_Y,    30
.equ LEGEND_X_BASE,  180
.equ LEGEND_Y_BASE,  40
.equ LEGEND_COL_GAP, 160
.equ LEGEND_ROW_GAP, 25

// Internal Cell Offsets
.equ CELL_N_OFF_X,   8
.equ CELL_N_OFF_Y,   18
.equ CELL_S_OFF_X,   35
.equ CELL_S_OFF_Y,   50

svg_header:
    .ascii "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 1150 820\" width=\"1150\" height=\"820\" style=\"font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;\">\n\0"

rect_start: .ascii "    <g>\n        <rect x=\"\0"
rect_y:     .ascii "\" y=\"\0"
rect_end:   .ascii "\" width=\"56\" height=\"70\" rx=\"4\" fill=\"\0"
stroke_end: .ascii "\" stroke=\"#555\" stroke-width=\"1\" />\n\0"

text_n_start: .ascii "        <text x=\"\0"
text_n_y:     .ascii "\" y=\"\0"
text_n_end:   .ascii "\" fill=\"#444\" font-size=\"10\">\0"
text_n_close: .ascii "</text>\n\0"

text_s_start: .ascii "        <text x=\"\0"
text_s_y:     .ascii "\" y=\"\0"
text_s_end:   .ascii "\" text-anchor=\"middle\" fill=\"#222\" font-size=\"22\" font-weight=\"bold\">\0"
text_s_close: .ascii "</text>\n\0"
text_marker_end: .ascii "\" text-anchor=\"middle\" font-family=\"sans-serif\" font-weight=\"bold\" fill=\"#222\" font-size=\"12\" textLength=\"48\" lengthAdjust=\"spacingAndGlyphs\">\0"

text_ja_start: .ascii "        <text x=\"\0"
text_ja_y:     .ascii "\" y=\"\0"
text_ja_end:   .ascii "\" text-anchor=\"middle\" fill=\"#222\" font-size=\"10\">\0"
text_ja_mid:   .ascii "\" text-anchor=\"middle\" fill=\"#222\" font-size=\"9\" textLength=\"50\" lengthAdjust=\"spacingAndGlyphs\">\0"
text_ja_long:  .ascii "\" text-anchor=\"middle\" fill=\"#222\" font-size=\"8\" textLength=\"50\" lengthAdjust=\"spacingAndGlyphs\">\0"
text_ja_close: .ascii "</text>\n    </g>\n\0"
g_close:       .ascii "    </g>\n\0"

legend_title: .ascii "\0" // Remove legend title
legend_rect_1: .ascii "    <rect x=\"\0"
legend_rect_1b: .ascii "\" y=\"\0"
legend_rect_2: .ascii "\" width=\"16\" height=\"16\" rx=\"2\" fill=\"\0"
legend_rect_3: .ascii "\" stroke=\"#555\" stroke-width=\"1\" />\n    <text x=\"\0"
legend_rect_4: .ascii "\" y=\"\0"
legend_rect_5: .ascii "\" fill=\"#333\" font-size=\"12\" alignment-baseline=\"middle\">\0"
legend_rect_close: .ascii "</text>\n\0"

label_group_start: .ascii "    <text x=\"\0"
label_group_y:     .ascii "\" y=\"\0"
label_group_end:   .ascii "\" text-anchor=\"middle\" fill=\"#666\" font-size=\"14\" font-weight=\"bold\">\0"
label_group_close: .ascii "</text>\n\0"

label_period_start: .ascii "    <text x=\"\0"
label_period_y:     .ascii "\" y=\"\0"
label_period_end:   .ascii "\" text-anchor=\"middle\" fill=\"#666\" font-size=\"14\" font-weight=\"bold\">\0"
label_period_close: .ascii "</text>\n\0"

svg_footer: .ascii "\n</svg>\n\0"

range_lan: .ascii "57-71\0"
range_act: .ascii "89-103\0"
color_lan: .ascii "#ffbfff\0"
color_act: .ascii "#ff99cc\0"

// Block labels removed for cleaner design

// --- Macros for SVG fragments ---
.macro print_tag_val tag_start, val, tag_end
    ldr x0, =\tag_start
    bl print_string
    mov x0, \val
    bl print_int
    ldr x0, =\tag_end
    bl print_string
.endm

.macro print_tag_str tag_start, str_ptr, tag_end
    ldr x0, =\tag_start
    bl print_string
    mov x0, \str_ptr
    bl print_string
    ldr x0, =\tag_end
    bl print_string
.endm

.section .text
.global _start

// Register Usage Overview:
// x19: Data pointer (elements/categories)
// x20: Loop counter / Total count
// x21: Atomic Number (n)
// x22: Group (g) / Column
// x23: Period (p) / Row
// x24: Symbol pointer (s)
// x25: Name pointer (ja)
// x26: Color pointer
// x27: Calculated X coordinate
// x28: Calculated Y coordinate

// Syscalls
.equ SYS_WRITE, 64
.equ SYS_EXIT,  93
.equ STDOUT,    1

_start:
    // Print Header
    ldr x0, =svg_header
    bl print_string

    // --- Render Group Labels (1-18) ---
    mov x19, #1
group_label_loop:
    cmp x19, #18
    bgt group_label_done
    
    // X = OFFSET_X + (g-1)*CELL_STEP_X + CELL_WIDTH/2
    sub x0, x19, #1
    mov x1, #CELL_STEP_X
    mul x0, x0, x1
    add x0, x0, #OFFSET_X
    add x21, x0, #28     // CELL_WIDTH/2 (56/2)
    
    ldr x0, =label_group_start
    bl print_string
    mov x0, x21
    bl print_int
    ldr x0, =label_group_y
    bl print_string
    mov x0, #(OFFSET_Y - 10)
    bl print_int
    ldr x0, =label_group_end
    bl print_string
    mov x0, x19
    bl print_int
    ldr x0, =label_group_close
    bl print_string
    
    add x19, x19, #1
    b group_label_loop
group_label_done:

    // --- Render Period Labels (1-7) ---
    mov x19, #1
period_label_loop:
    cmp x19, #7
    bgt period_label_done
    
    // Y = OFFSET_Y + (p-1)*CELL_STEP_Y + (CELL_HEIGHT / 2 + 5)
    sub x0, x19, #1
    mov x1, #CELL_STEP_Y
    mul x0, x0, x1
    add x21, x0, #(OFFSET_Y + (CELL_HEIGHT / 2 + 5))
    
    ldr x0, =label_period_start
    bl print_string
    mov x0, #(OFFSET_X - 15)
    bl print_int
    ldr x0, =label_period_y
    bl print_string
    mov x0, x21
    bl print_int
    ldr x0, =label_period_end
    bl print_string
    mov x0, x19
    bl print_int
    ldr x0, =label_period_close
    bl print_string
    
    add x19, x19, #1
    b period_label_loop
period_label_done:

    // Loop through elements
    ldr x19, =elements_data
    ldr x20, =elements_total_count
    ldr x20, [x20]
    
element_loop:
    cbz x20, loop_end

    // Load data
    ldr x21, [x19]       // n (atomic number)
    ldr x22, [x19, #8]    // g (group)
    ldr x23, [x19, #16]   // p (period)
    add x24, x19, #24    // s (symbol pointer)
    
    // Find next pointers (strings are null-terminated and aligned)
    mov x0, x24
    bl strlen
    add x0, x0, #1
    add x0, x0, #7
    and x0, x0, #-8
    add x25, x24, x0     // ja (Japanese name pointer)
    
    mov x0, x25
    bl strlen
    add x0, x0, #1
    add x0, x0, #7
    and x0, x0, #-8
    add x26, x25, x0     // color pointer

    // Calculate Coordinates
    mov x0, x22          // group
    mov x1, x23          // period
    bl calculate_coords
    mov x27, x0          // x_coord
    mov x28, x1          // y_coord

    // 1. Print Rectangle (Card background)
    ldr x0, =rect_start
    bl print_string
    mov x0, x27
    bl print_int
    ldr x0, =rect_y
    bl print_string
    mov x0, x28
    bl print_int
    ldr x0, =rect_end
    bl print_string
    mov x0, x26          // color for stroke
    bl print_string
    ldr x0, =stroke_end
    bl print_string

    // 2. Print Atomic Number (n)
    ldr x0, =text_n_start
    bl print_string
    add x0, x27, #4      // Top-left offset from HTML: x + 4
    bl print_int
    ldr x0, =text_n_y
    bl print_string
    add x0, x28, #14     // Top-left offset from HTML: y + 14
    bl print_int
    ldr x0, =text_n_end
    bl print_string
    mov x0, x21          // n
    bl print_int
    ldr x0, =text_n_close
    bl print_string

    // 3. Print Symbol (s)
    ldr x0, =text_s_start
    bl print_string
    add x0, x27, #28     // Centered: CELL_WIDTH/2 = 56/2 = 28
    bl print_int
    ldr x0, =text_s_y
    bl print_string
    add x0, x28, #42     // y + 42 from HTML
    bl print_int
    ldr x0, =text_s_end
    bl print_string
    mov x0, x24          // s (pointer)
    bl print_string
    ldr x0, =text_s_close
    bl print_string

    // 4. Print Japanese Name (ja)
    // Calculate character count for overflow handling
    mov x0, x25          // ja pointer
    bl utf8_char_count
    mov x21, x0          // character count
    
    ldr x0, =text_ja_start
    bl print_string
    add x0, x27, #28     // Centered
    bl print_int
    ldr x0, =text_ja_y
    bl print_string
    add x0, x28, #60     // y + 60
    bl print_int
    
    // Select template based on count
    cmp x21, #8
    bge .ja_long
    cmp x21, #6
    bge .ja_mid
    ldr x0, =text_ja_end
    b .ja_print
.ja_long:
    ldr x0, =text_ja_long
    b .ja_print
.ja_mid:
    ldr x0, =text_ja_mid
.ja_print:
    bl print_string
    mov x0, x25          // ja pointer
    bl print_string
    ldr x0, =text_ja_close
    bl print_string

    // Move to next element data
    mov x0, x26
    bl strlen
    add x0, x0, #1
    add x0, x0, #7
    and x0, x0, #-8
    add x19, x26, x0
    
    sub x20, x20, #1
    b element_loop

loop_end:
    // --- Render Special Elements (Lanthanide/Actinide Markers) ---
    
    // 1. Lanthanide Marker (g=3, p=6)
    mov x0, #3           // group
    mov x1, #6           // period
    bl calculate_coords
    mov x27, x0
    mov x28, x1

    ldr x0, =rect_start
    bl print_string
    mov x0, x27
    bl print_int
    ldr x0, =rect_y
    bl print_string
    mov x0, x28
    bl print_int
    ldr x0, =rect_end
    bl print_string
    ldr x0, =color_lan   // Actually #ffbfff now
    bl print_string
    ldr x0, =stroke_end
    bl print_string
    
    ldr x0, =text_s_start
    bl print_string
    add x0, x27, #28
    bl print_int
    ldr x0, =text_s_y
    bl print_string
    add x0, x28, #42
    bl print_int
    ldr x0, =text_marker_end
    bl print_string
    // In HTML it uses text-anchor="middle", font-size="12px", content="57-71"
    // I need a special template for marker text if I want to be exact,
    // but let's see if we can reuse text_s with a smaller font.
    // Wait, I should just define a marker text template.
    ldr x0, =range_lan
    bl print_string
    ldr x0, =text_s_close
    bl print_string
    ldr x0, =g_close
    bl print_string

    // 2. Actinide Marker (g=3, p=7)
    mov x0, #3           // group
    mov x1, #7           // period
    bl calculate_coords
    mov x27, x0
    mov x28, x1

    ldr x0, =rect_start
    bl print_string
    mov x0, x27
    bl print_int
    ldr x0, =rect_y
    bl print_string
    mov x0, x28
    bl print_int
    ldr x0, =rect_end
    bl print_string
    ldr x0, =color_act   // Actually #ff99cc now
    bl print_string
    ldr x0, =stroke_end
    bl print_string
    
    ldr x0, =text_s_start
    bl print_string
    add x0, x27, #28
    bl print_int
    ldr x0, =text_s_y
    bl print_string
    add x0, x28, #42
    bl print_int
    ldr x0, =text_marker_end
    bl print_string
    ldr x0, =range_act
    bl print_string
    ldr x0, =text_s_close
    bl print_string
    ldr x0, =g_close
    bl print_string

    // (Series labels and lines removed as they are not in main.html)


    // --- End Special Elements ---
    
    // Render Legend Title
    ldr x0, =legend_title
    bl print_string

    // Render Legend Items (Multi-column)
    ldr x19, =categories_data
    ldr x20, =categories_count
    ldr x20, [x20]
    mov x22, #0          // item index
legend_loop:
    cmp x22, x20
    bge legend_done
    
    // Calculate Col and Row (Column-major: 4 items per column)
    mov x1, #4
    udiv x24, x22, x1      // x24 = Col (index / 4)
    msub x23, x24, x1, x22 // x23 = Row (index % 4)
    
    // X = LEGEND_X_BASE + Col * LEGEND_COL_GAP
    mov x1, #LEGEND_COL_GAP
    mul x0, x24, x1
    add x25, x0, #LEGEND_X_BASE
    
    // Y = LEGEND_Y_BASE + Row * LEGEND_ROW_GAP
    mov x1, #LEGEND_ROW_GAP
    mul x0, x23, x1
    add x26, x0, #LEGEND_Y_BASE
    
    // Print item rect
    ldr x0, =legend_rect_1
    bl print_string
    mov x0, x25
    bl print_int
    ldr x0, =legend_rect_1b
    bl print_string
    mov x0, x26
    bl print_int
    ldr x0, =legend_rect_2
    bl print_string
    
    // x19 points to color string
    mov x0, x19
    bl print_string
    
    ldr x0, =legend_rect_3
    bl print_string

    // Print text
    add x0, x25, #24     // lx + 24
    bl print_int
    ldr x0, =legend_rect_4
    bl print_string
    add x0, x26, #12     // ly + 12
    bl print_int
    ldr x0, =legend_rect_5
    bl print_string

    // Advance x19 to label
    mov x0, x19
    bl strlen
    add x19, x19, x0
    add x19, x19, #1     // Skip null
    
    // x19 points to label string
    mov x0, x19
    bl print_string
    
    // Advance x19 to next category
    mov x0, x19
    bl strlen
    add x19, x19, x0
    add x19, x19, #1     // Skip null
    
    ldr x0, =legend_rect_close
    bl print_string
    
    add x22, x22, #1
    b legend_loop

legend_done:
    // Print Footer
    ldr x0, =svg_footer
    bl print_string

    // Exit
    mov x0, #0
    mov x8, #SYS_EXIT
    svc #0

// Helper: print_string(x0: pointer)
print_string:
    stp x29, x30, [sp, #-32]!
    str x0, [sp, #16]    // Save pointer on stack
    bl strlen
    mov x2, x0          // length
    ldr x1, [sp, #16]    // Restore pointer to x1
    mov x0, #STDOUT
    mov x8, #SYS_WRITE
    svc #0
    ldp x29, x30, [sp], #32
    ret

// Helper: strlen(x0: pointer) -> x0: length
strlen:
    mov x1, #0
strlen_loop:
    ldrb w2, [x0, x1]
    cbz w2, strlen_done
    add x1, x1, #1
    b strlen_loop
strlen_done:
    mov x0, x1
    ret

// Helper: print_int(x0: integer)
print_int:
    stp x29, x30, [sp, #-48]!
    mov x1, sp
    add x1, x1, #40     // Buffer at end of stack frame
    mov w2, #10
    mov w3, #0          // length
print_int_loop:
    udiv x4, x0, x2
    msub x5, x4, x2, x0 // x5 = x0 % 10
    add x5, x5, #'0'
    sub x1, x1, #1
    strb w5, [x1]
    add w3, w3, #1
    mov x0, x4
    cbnz x0, print_int_loop
    
    // Write the digits
    mov x2, x3
    // x1 points to the start of digits
    mov x0, #STDOUT
    mov x8, #SYS_WRITE
    svc #0
    
    ldp x29, x30, [sp], #48
    ret

// Helper: calculate_coords(x0: group, x1: period) -> x0: x_coord, x1: y_coord
calculate_coords:
    stp x29, x30, [sp, #-16]!
    mov x2, x0          // group
    mov x3, x1          // period

    // X = OFFSET_X + (group - 1) * CELL_STEP_X
    sub x0, x2, #1
    mov x4, #CELL_STEP_X
    mul x0, x0, x4
    add x0, x0, #OFFSET_X
    
    // Y = OFFSET_Y + (period - 1) * CELL_STEP_Y
    sub x1, x3, #1
    mov x4, #CELL_STEP_Y
    mul x1, x1, x4
    add x1, x1, #OFFSET_Y
    
    // Adjust Y for Lanthanides/Actinides (period > 7)
    cmp x3, #7
    ble .coords_done
    add x1, x1, #BLOCK_GAP_Y
.coords_done:
    ldp x29, x30, [sp], #16
    ret

// Helper: utf8_char_count(x0: pointer) -> x0: count
utf8_char_count:
    mov x1, #0          // count
    mov x2, #0          // index
.utf8_loop:
    ldrb w3, [x0, x2]
    cbz w3, .utf8_done
    // Count only bytes that are NOT continuation bytes (10xxxxxx)
    and w4, w3, #0xC0
    cmp w4, #0x80
    cset w4, ne         // w4 = 1 if not a continuation byte
    add x1, x1, x4
    add x2, x2, #1
    b .utf8_loop
.utf8_done:
    mov x0, x1
    ret
