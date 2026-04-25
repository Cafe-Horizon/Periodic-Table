// src/elements.inc - Full 118 element data definition for AArch64 Assembly
// Format: element_def atomic_number, group, period, symbol, name_ja, color

.set element_count, 0

.macro element_def n, g, p, symbol, name, color
    .quad \n
    .quad \g
    .quad \p
    .asciz "\symbol"
    .align 3
    .asciz "\name"
    .align 3
    .asciz "\color"
    .align 3
    .set element_count, element_count + 1
.endm

.section .rodata
.global elements_data
.global elements_total_count

elements_data:
    // Period 1
    element_def 1, 1, 1, "H", "水素", "#a0ffa0"
    element_def 2, 18, 1, "He", "ヘリウム", "#c0ffff"

    // Period 2
    element_def 3, 1, 2, "Li", "リチウム", "#ff6666"
    element_def 4, 2, 2, "Be", "ベリリウム", "#ffdead"
    element_def 5, 13, 2, "B", "ホウ素", "#cccc99"
    element_def 6, 14, 2, "C", "炭素", "#a0ffa0"
    element_def 7, 15, 2, "N", "窒素", "#a0ffa0"
    element_def 8, 16, 2, "O", "酸素", "#a0ffa0"
    element_def 9, 17, 2, "F", "フッ素", "#ffff99"
    element_def 10, 18, 2, "Ne", "ネオン", "#c0ffff"

    // Period 3
    element_def 11, 1, 3, "Na", "ナトリウム", "#ff6666"
    element_def 12, 2, 3, "Mg", "マグネシウム", "#ffdead"
    element_def 13, 13, 3, "Al", "アルミニウム", "#cccccc"
    element_def 14, 14, 3, "Si", "ケイ素", "#cccc99"
    element_def 15, 15, 3, "P", "リン", "#a0ffa0"
    element_def 16, 16, 3, "S", "硫黄", "#a0ffa0"
    element_def 17, 17, 3, "Cl", "塩素", "#ffff99"
    element_def 18, 18, 3, "Ar", "アルゴン", "#c0ffff"

    // Period 4
    element_def 19, 1, 4, "K", "カリウム", "#ff6666"
    element_def 20, 2, 4, "Ca", "カルシウム", "#ffdead"
    element_def 21, 3, 4, "Sc", "スカンジウム", "#ffc0c0"
    element_def 22, 4, 4, "Ti", "チタン", "#ffc0c0"
    element_def 23, 5, 4, "V", "バナジウム", "#ffc0c0"
    element_def 24, 6, 4, "Cr", "クロム", "#ffc0c0"
    element_def 25, 7, 4, "Mn", "マンガン", "#ffc0c0"
    element_def 26, 8, 4, "Fe", "鉄", "#ffc0c0"
    element_def 27, 9, 4, "Co", "コバルト", "#ffc0c0"
    element_def 28, 10, 4, "Ni", "ニッケル", "#ffc0c0"
    element_def 29, 11, 4, "Cu", "銅", "#ffc0c0"
    element_def 30, 12, 4, "Zn", "亜鉛", "#ffc0c0"
    element_def 31, 13, 4, "Ga", "ガリウム", "#cccccc"
    element_def 32, 14, 4, "Ge", "ゲルマニウム", "#cccc99"
    element_def 33, 15, 4, "As", "ヒ素", "#cccc99"
    element_def 34, 16, 4, "Se", "セレン", "#a0ffa0"
    element_def 35, 17, 4, "Br", "臭素", "#ffff99"
    element_def 36, 18, 4, "Kr", "クリプトン", "#c0ffff"

    // Period 5
    element_def 37, 1, 5, "Rb", "ルビジウム", "#ff6666"
    element_def 38, 2, 5, "Sr", "ストロンチウム", "#ffdead"
    element_def 39, 3, 5, "Y", "イットリウム", "#ffc0c0"
    element_def 40, 4, 5, "Zr", "ジルコニウム", "#ffc0c0"
    element_def 41, 5, 5, "Nb", "ニオブ", "#ffc0c0"
    element_def 42, 6, 5, "Mo", "モリブデン", "#ffc0c0"
    element_def 43, 7, 5, "Tc", "テクネチウム", "#ffc0c0"
    element_def 44, 8, 5, "Ru", "ルテニウム", "#ffc0c0"
    element_def 45, 9, 5, "Rh", "ロジウム", "#ffc0c0"
    element_def 46, 10, 5, "Pd", "パラジウム", "#ffc0c0"
    element_def 47, 11, 5, "Ag", "銀", "#ffc0c0"
    element_def 48, 12, 5, "Cd", "カドミウム", "#ffc0c0"
    element_def 49, 13, 5, "In", "インジウム", "#cccccc"
    element_def 50, 14, 5, "Sn", "スズ", "#cccccc"
    element_def 51, 15, 5, "Sb", "アンチモン", "#cccc99"
    element_def 52, 16, 5, "Te", "テルル", "#cccc99"
    element_def 53, 17, 5, "I", "ヨウ素", "#ffff99"
    element_def 54, 18, 5, "Xe", "キセノン", "#c0ffff"

    // Period 6
    element_def 55, 1, 6, "Cs", "セシウム", "#ff6666"
    element_def 56, 2, 6, "Ba", "バリウム", "#ffdead"
    // Lanthanides (p:8)
    element_def 57, 3, 8, "La", "ランタン", "#ffbfff"
    element_def 58, 4, 8, "Ce", "セリウム", "#ffbfff"
    element_def 59, 5, 8, "Pr", "プラセオジム", "#ffbfff"
    element_def 60, 6, 8, "Nd", "ネオジム", "#ffbfff"
    element_def 61, 7, 8, "Pm", "プロメチウム", "#ffbfff"
    element_def 62, 8, 8, "Sm", "サマリウム", "#ffbfff"
    element_def 63, 9, 8, "Eu", "ユウロピウム", "#ffbfff"
    element_def 64, 10, 8, "Gd", "ガドリニウム", "#ffbfff"
    element_def 65, 11, 8, "Tb", "テルビウム", "#ffbfff"
    element_def 66, 12, 8, "Dy", "ジスプロシウム", "#ffbfff"
    element_def 67, 13, 8, "Ho", "ホルミウム", "#ffbfff"
    element_def 68, 14, 8, "Er", "エルビウム", "#ffbfff"
    element_def 69, 15, 8, "Tm", "ツリウム", "#ffbfff"
    element_def 70, 16, 8, "Yb", "イッテルビウム", "#ffbfff"
    element_def 71, 17, 8, "Lu", "ルテチウム", "#ffbfff"
    // Transition
    element_def 72, 4, 6, "Hf", "ハフニウム", "#ffc0c0"
    element_def 73, 5, 6, "Ta", "タンタル", "#ffc0c0"
    element_def 74, 6, 6, "W", "タングステン", "#ffc0c0"
    element_def 75, 7, 6, "Re", "レニウム", "#ffc0c0"
    element_def 76, 8, 6, "Os", "オスミウム", "#ffc0c0"
    element_def 77, 9, 6, "Ir", "イリジウム", "#ffc0c0"
    element_def 78, 10, 6, "Pt", "白金", "#ffc0c0"
    element_def 79, 11, 6, "Au", "金", "#ffc0c0"
    element_def 80, 12, 6, "Hg", "水銀", "#ffc0c0"
    // Post-transition & others
    element_def 81, 13, 6, "Tl", "タリウム", "#cccccc"
    element_def 82, 14, 6, "Pb", "鉛", "#cccccc"
    element_def 83, 15, 6, "Bi", "ビスマス", "#cccccc"
    element_def 84, 16, 6, "Po", "ポロニウム", "#cccccc"
    element_def 85, 17, 6, "At", "アスタチン", "#ffff99"
    element_def 86, 18, 6, "Rn", "ラドン", "#c0ffff"

    // Period 7
    element_def 87, 1, 7, "Fr", "フランシウム", "#ff6666"
    element_def 88, 2, 7, "Ra", "ラジウム", "#ffdead"
    // Actinides (p:9)
    element_def 89, 3, 9, "Ac", "アクチニウム", "#ff99cc"
    element_def 90, 4, 9, "Th", "トリウム", "#ff99cc"
    element_def 91, 5, 9, "Pa", "プロトアクチニウム", "#ff99cc"
    element_def 92, 6, 9, "U", "ウラン", "#ff99cc"
    element_def 93, 7, 9, "Np", "ネプツニウム", "#ff99cc"
    element_def 94, 8, 9, "Pu", "プルトニウム", "#ff99cc"
    element_def 95, 9, 9, "Am", "アメリシウム", "#ff99cc"
    element_def 96, 10, 9, "Cm", "キュリウム", "#ff99cc"
    element_def 97, 11, 9, "Bk", "バークリウム", "#ff99cc"
    element_def 98, 12, 9, "Cf", "カリホルニウム", "#ff99cc"
    element_def 99, 13, 9, "Es", "アインシュタニウム", "#ff99cc"
    element_def 100, 14, 9, "Fm", "フェルミウム", "#ff99cc"
    element_def 101, 15, 9, "Md", "メンデレビウム", "#ff99cc"
    element_def 102, 16, 9, "No", "ノーベリウム", "#ff99cc"
    element_def 103, 17, 9, "Lr", "ローレンシウム", "#ff99cc"
    // Transactinides
    element_def 104, 4, 7, "Rf", "ラザホージウム", "#ffc0c0"
    element_def 105, 5, 7, "Db", "ドブニウム", "#ffc0c0"
    element_def 106, 6, 7, "Sg", "シーボーギウム", "#ffc0c0"
    element_def 107, 7, 7, "Bh", "ボーリウム", "#ffc0c0"
    element_def 108, 8, 7, "Hs", "ハッシウム", "#ffc0c0"
    element_def 109, 9, 7, "Mt", "マイトネリウム", "#e8e8e8"
    element_def 110, 10, 7, "Ds", "ダームスタチウム", "#e8e8e8"
    element_def 111, 11, 7, "Rg", "レントゲニウム", "#e8e8e8"
    element_def 112, 12, 7, "Cn", "コペルニシウム", "#ffc0c0"
    element_def 113, 13, 7, "Nh", "ニホニウム", "#e8e8e8"
    element_def 114, 14, 7, "Fl", "フレロビウム", "#e8e8e8"
    element_def 115, 15, 7, "Mc", "モスコビウム", "#e8e8e8"
    element_def 116, 16, 7, "Lv", "リバモリウム", "#e8e8e8"
    element_def 117, 17, 7, "Ts", "テネシン", "#e8e8e8"
    element_def 118, 18, 7, "Og", "オガネソン", "#e8e8e8"

elements_total_count:
    .quad element_count
