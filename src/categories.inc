// src/categories.inc - Maintainable category data for legend
// Format: category_def color, name_ja

.macro category_def color, name
    .asciz "\color"
    .asciz "\name"
.endm

.section .rodata
.global categories_data
.global categories_count

categories_data:
    category_def "#a0ffa0", "非金属"
    category_def "#c0ffff", "希ガス"
    category_def "#ff6666", "アルカリ金属"
    category_def "#ffdead", "アルカリ土類金属"
    category_def "#cccc99", "半金属"
    category_def "#ffff99", "ハロゲン"
    category_def "#ffc0c0", "遷移金属"
    category_def "#cccccc", "その他の金属"
    category_def "#ffbfff", "ランタノイド"
    category_def "#ff99cc", "アクチノイド"
    category_def "#e8e8e8", "性質未確定"
categories_end:

.equ NUM_CATEGORIES, 11
categories_count:
    .quad NUM_CATEGORIES
