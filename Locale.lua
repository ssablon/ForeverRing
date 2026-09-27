local addonName, ns = ...

local L = {}

L.enUS = {
	TITLE = "Forever Ring",
	TITLE_SUB = "(Multi language)",
	INIT = "Loaded. /fring options",
	OPTIONS_TITLE = "Forever Ring — Options",
	SWITCH_ON = "ON",
	SWITCH_OFF = "OFF",
	TAB_RING = "Ring",
	TAB_INFO = "Info",
	OPT_CARD_CURSOR = "Cursor ring",
	OPT_CARD_CAST = "Cast",
	OPT_CARD_RANGE = "Target range",
	OPT_CARD_ABOUT = "About",
	OPT_CARD_COMMANDS = "Commands",
	OPT_CARD_LINKS = "Links",
	OPT_ENABLE_RING = "Show cursor ring",
	OPT_ENABLE_CAST = "Show cast on the ring",
	OPT_ENABLE_RANGE = "Show range around the ring",
	OPT_RANGE_TEXT = "Show yard numbers",
	OPT_ONLY_COMBAT = "Only in combat",
	OPT_ONLY_ENEMY = "Only hostile targets",
	OPT_OUT_OF_COMBAT = "Show out of combat",
	OPT_RING_SIZE = "Ring size: %d",
	OPT_RANGE_GAP = "Range ring gap: %d",
	OPT_CLASS_COLOR = "Use class color",
	OPT_RING_COLOR = "Ring color",
	OPT_RESET_CLASS = "Class",
	INFO_ABOUT = "Forever Ring draws a ring on the mouse and a second circle around it for target distance. It never casts.",
	INFO_ABOUT_POINTS = "• Ring on the cursor, range circle around it\n• Cast progress on the ring\n• Interface in 11 languages — English fallback",
	INFO_CREDIT = "Created by Vohnka",
	INFO_SUPPORT = "Support is on Discord only, in English (#support, #bugs, #suggestions).",
	INFO_CMD_HINT = "Slash commands — also /foreverring:",
	INFO_CMD_LIST = "/fring — help\n/fring options — this window\n/fring toggle — show or hide",
	INFO_SITE = "Website",
	INFO_DISCORD = "Discord",
	INFO_COPY = "Copy",
	INFO_COPIED = "The link is in the chat box. Press Ctrl+C to copy.",
	HELP = "/fring options | toggle",
	LOCKED = "On.",
	UNLOCKED = "Off.",
	MINIMAP_L = "Left-click: options",
	MINIMAP_R = "Right-click: show or hide the rings. Drag to move.",
	OPT_MINIMAP = "Show minimap button",
	OPT_LANG = "Language",
}

L.frFR = {
	TITLE_SUB = "(Multi language)",
	INIT = "Chargé. /fring options",
	OPTIONS_TITLE = "Forever Ring — Options",
	TAB_RING = "Anneau",
	TAB_INFO = "Info",
	OPT_CARD_CURSOR = "Anneau du curseur",
	OPT_CARD_CAST = "Incantation",
	OPT_CARD_RANGE = "Portée de la cible",
	OPT_CARD_ABOUT = "À propos",
	OPT_CARD_COMMANDS = "Commandes",
	OPT_CARD_LINKS = "Liens",
	OPT_ENABLE_RING = "Afficher l'anneau du curseur",
	OPT_ENABLE_CAST = "Afficher l'incantation sur l'anneau",
	OPT_ENABLE_RANGE = "Afficher la portée autour de l'anneau",
	OPT_RANGE_TEXT = "Afficher les yards",
	OPT_ONLY_COMBAT = "Seulement en combat",
	OPT_ONLY_ENEMY = "Seulement les cibles hostiles",
	OPT_OUT_OF_COMBAT = "Afficher hors combat",
	OPT_RING_SIZE = "Taille de l'anneau : %d",
	OPT_RANGE_GAP = "Écart de l'anneau de portée : %d",
	OPT_CLASS_COLOR = "Couleur de classe",
	OPT_RING_COLOR = "Couleur de l'anneau",
	OPT_RESET_CLASS = "Classe",
	INFO_ABOUT = "Forever Ring dessine un anneau sur la souris et un second cercle autour pour la distance de la cible. Il ne lance aucun sort.",
	INFO_ABOUT_POINTS = "• Anneau sur le curseur, cercle de portée autour\n• Progression d'incantation sur l'anneau\n• Interface en 11 langues — repli anglais",
	INFO_CREDIT = "Créé par Vohnka",
	INFO_SUPPORT = "Le support est uniquement sur Discord, en anglais (#support, #bugs, #suggestions).",
	INFO_CMD_HINT = "Commandes slash — aussi /foreverring :",
	INFO_CMD_LIST = "/fring — aide\n/fring options — cette fenêtre\n/fring toggle — afficher ou cacher",
	INFO_SITE = "Site",
	INFO_DISCORD = "Discord",
	INFO_COPY = "Copier",
	INFO_COPIED = "Le lien est dans la boîte de chat. Ctrl+C pour copier.",
	HELP = "/fring options | toggle",
	LOCKED = "Activé.",
	UNLOCKED = "Désactivé.",
	MINIMAP_L = "Clic gauche : options",
	MINIMAP_R = "Clic droit : afficher ou cacher les anneaux. Glisser pour déplacer.",
	OPT_MINIMAP = "Bouton de la minimap",
	OPT_LANG = "Langue",
}

L.deDE = {
	TITLE_SUB = "(Multi language)",
	INIT = "Geladen. /fring options",
	OPTIONS_TITLE = "Forever Ring — Optionen",
	TAB_RING = "Ring",
	TAB_INFO = "Info",
	OPT_CARD_CURSOR = "Cursor-Ring",
	OPT_CARD_CAST = "Zauber",
	OPT_CARD_RANGE = "Zielreichweite",
	OPT_CARD_ABOUT = "Über",
	OPT_CARD_COMMANDS = "Befehle",
	OPT_CARD_LINKS = "Links",
	OPT_ENABLE_RING = "Cursor-Ring anzeigen",
	OPT_ENABLE_CAST = "Zauberfortschritt auf dem Ring",
	OPT_ENABLE_RANGE = "Reichweite um den Ring anzeigen",
	OPT_RANGE_TEXT = "Yard-Zahlen anzeigen",
	OPT_ONLY_COMBAT = "Nur im Kampf",
	OPT_ONLY_ENEMY = "Nur feindliche Ziele",
	OPT_OUT_OF_COMBAT = "Außerhalb des Kampfes anzeigen",
	OPT_RING_SIZE = "Ringgröße: %d",
	OPT_RANGE_GAP = "Abstand des Reichweitenrings: %d",
	OPT_CLASS_COLOR = "Klassenfarbe verwenden",
	OPT_RING_COLOR = "Ringfarbe",
	OPT_RESET_CLASS = "Klasse",
	INFO_ABOUT = "Forever Ring zeichnet einen Ring an den Mauszeiger und einen zweiten Kreis für die Zieldistanz. Es zaubert nie.",
	INFO_ABOUT_POINTS = "• Ring am Cursor, Reichweitenkreis darum\n• Zauberfortschritt auf dem Ring\n• Oberfläche in 11 Sprachen — Englisch als Fallback",
	INFO_CREDIT = "Erstellt von Vohnka",
	INFO_SUPPORT = "Support nur auf Discord, auf Englisch (#support, #bugs, #suggestions).",
	INFO_CMD_HINT = "Slash-Befehle — auch /foreverring:",
	INFO_CMD_LIST = "/fring — Hilfe\n/fring options — dieses Fenster\n/fring toggle — ein- oder ausblenden",
	INFO_SITE = "Website",
	INFO_DISCORD = "Discord",
	INFO_COPY = "Kopieren",
	INFO_COPIED = "Der Link steht im Chatfeld. Strg+C zum Kopieren.",
	HELP = "/fring options | toggle",
	LOCKED = "An.",
	UNLOCKED = "Aus.",
	MINIMAP_L = "Linksklick: Optionen",
	MINIMAP_R = "Rechtsklick: Ringe ein- oder ausblenden. Ziehen zum Verschieben.",
	OPT_MINIMAP = "Minikarten-Button anzeigen",
	OPT_LANG = "Sprache",
}

L.esES = {
	TITLE_SUB = "(Multi language)",
	INIT = "Cargado. /fring options",
	OPTIONS_TITLE = "Forever Ring — Opciones",
	TAB_RING = "Anillo",
	TAB_INFO = "Info",
	OPT_CARD_CURSOR = "Anillo del cursor",
	OPT_CARD_CAST = "Lanzamiento",
	OPT_CARD_RANGE = "Alcance del objetivo",
	OPT_CARD_ABOUT = "Acerca de",
	OPT_CARD_COMMANDS = "Comandos",
	OPT_CARD_LINKS = "Enlaces",
	OPT_ENABLE_RING = "Mostrar el anillo del cursor",
	OPT_ENABLE_CAST = "Mostrar el lanzamiento en el anillo",
	OPT_ENABLE_RANGE = "Mostrar el alcance alrededor del anillo",
	OPT_RANGE_TEXT = "Mostrar las yardas",
	OPT_ONLY_COMBAT = "Solo en combate",
	OPT_ONLY_ENEMY = "Solo objetivos hostiles",
	OPT_OUT_OF_COMBAT = "Mostrar fuera de combate",
	OPT_RING_SIZE = "Tamaño del anillo: %d",
	OPT_RANGE_GAP = "Separación del anillo de alcance: %d",
	OPT_CLASS_COLOR = "Usar color de clase",
	OPT_RING_COLOR = "Color del anillo",
	OPT_RESET_CLASS = "Clase",
	INFO_ABOUT = "Forever Ring dibuja un anillo en el ratón y un segundo círculo con la distancia al objetivo. Nunca lanza hechizos.",
	INFO_ABOUT_POINTS = "• Anillo en el cursor, círculo de alcance alrededor\n• Progreso de lanzamiento en el anillo\n• Interfaz en 11 idiomas — inglés como respaldo",
	INFO_CREDIT = "Creado por Vohnka",
	INFO_SUPPORT = "El soporte está solo en Discord, en inglés (#support, #bugs, #suggestions).",
	INFO_CMD_HINT = "Comandos — también /foreverring:",
	INFO_CMD_LIST = "/fring — ayuda\n/fring options — esta ventana\n/fring toggle — mostrar u ocultar",
	INFO_SITE = "Sitio",
	INFO_DISCORD = "Discord",
	INFO_COPY = "Copiar",
	INFO_COPIED = "El enlace está en el chat. Pulsa Ctrl+C para copiar.",
	HELP = "/fring options | toggle",
	LOCKED = "Activado.",
	UNLOCKED = "Desactivado.",
	MINIMAP_L = "Clic izquierdo: opciones",
	MINIMAP_R = "Clic derecho: mostrar u ocultar los anillos. Arrastra para mover.",
	OPT_MINIMAP = "Mostrar botón del minimapa",
	OPT_LANG = "Idioma",
}

L.ruRU = {
	TITLE_SUB = "(Multi language)",
	INIT = "Загружено. /fring options",
	OPTIONS_TITLE = "Forever Ring — Настройки",
	TAB_RING = "Кольцо",
	TAB_INFO = "Инфо",
	OPT_CARD_CURSOR = "Кольцо курсора",
	OPT_CARD_CAST = "Применение",
	OPT_CARD_RANGE = "Дальность цели",
	OPT_CARD_ABOUT = "О аддоне",
	OPT_CARD_COMMANDS = "Команды",
	OPT_CARD_LINKS = "Ссылки",
	OPT_ENABLE_RING = "Показывать кольцо курсора",
	OPT_ENABLE_CAST = "Показывать применение на кольце",
	OPT_ENABLE_RANGE = "Показывать дальность вокруг кольца",
	OPT_RANGE_TEXT = "Показывать ярды",
	OPT_ONLY_COMBAT = "Только в бою",
	OPT_ONLY_ENEMY = "Только враждебные цели",
	OPT_OUT_OF_COMBAT = "Показывать вне боя",
	OPT_RING_SIZE = "Размер кольца: %d",
	OPT_RANGE_GAP = "Отступ кольца дальности: %d",
	OPT_CLASS_COLOR = "Цвет класса",
	OPT_RING_COLOR = "Цвет кольца",
	OPT_RESET_CLASS = "Класс",
	INFO_ABOUT = "Forever Ring рисует кольцо на курсоре и второй круг для дистанции до цели. Он не применяет заклинания.",
	INFO_ABOUT_POINTS = "• Кольцо на курсоре, круг дальности вокруг\n• Прогресс применения на кольце\n• Интерфейс на 11 языках — запасной английский",
	INFO_CREDIT = "Создано Vohnka",
	INFO_SUPPORT = "Поддержка только в Discord, на английском (#support, #bugs, #suggestions).",
	INFO_CMD_HINT = "Команды — также /foreverring:",
	INFO_CMD_LIST = "/fring — справка\n/fring options — это окно\n/fring toggle — показать или скрыть",
	INFO_SITE = "Сайт",
	INFO_DISCORD = "Discord",
	INFO_COPY = "Копировать",
	INFO_COPIED = "Ссылка в поле чата. Нажмите Ctrl+C, чтобы скопировать.",
	HELP = "/fring options | toggle",
	LOCKED = "Вкл.",
	UNLOCKED = "Выкл.",
	MINIMAP_L = "ЛКМ: настройки",
	MINIMAP_R = "ПКМ: показать или скрыть кольца. Перетащите, чтобы сдвинуть.",
	OPT_MINIMAP = "Кнопка у миникарты",
	OPT_LANG = "Язык",
}

L.zhCN = {
	TITLE_SUB = "(Multi language)",
	INIT = "已加载。/fring options",
	OPTIONS_TITLE = "Forever Ring — 选项",
	TAB_RING = "圆环",
	TAB_INFO = "信息",
	OPT_CARD_CURSOR = "鼠标圆环",
	OPT_CARD_CAST = "施法",
	OPT_CARD_RANGE = "目标距离",
	OPT_CARD_ABOUT = "关于",
	OPT_CARD_COMMANDS = "命令",
	OPT_CARD_LINKS = "链接",
	OPT_ENABLE_RING = "显示鼠标圆环",
	OPT_ENABLE_CAST = "在圆环上显示施法",
	OPT_ENABLE_RANGE = "在圆环外显示距离",
	OPT_RANGE_TEXT = "显示码数",
	OPT_ONLY_COMBAT = "仅在战斗中",
	OPT_ONLY_ENEMY = "仅敌对目标",
	OPT_OUT_OF_COMBAT = "非战斗时显示",
	OPT_RING_SIZE = "圆环大小：%d",
	OPT_RANGE_GAP = "距离环间距：%d",
	OPT_CLASS_COLOR = "使用职业颜色",
	OPT_RING_COLOR = "圆环颜色",
	OPT_RESET_CLASS = "职业",
	INFO_ABOUT = "Forever Ring 在鼠标上画一个圆环，并用外圈显示目标距离。它不会施法。",
	INFO_ABOUT_POINTS = "• 鼠标圆环，外圈显示距离\n• 圆环上显示施法进度\n• 界面支持 11 种语言 — 缺省英语",
	INFO_CREDIT = "由 Vohnka 制作",
	INFO_SUPPORT = "仅在 Discord 用英语提供支持（#support、#bugs、#suggestions）。",
	INFO_CMD_HINT = "斜杠命令 — 也可用 /foreverring：",
	INFO_CMD_LIST = "/fring — 帮助\n/fring options — 本窗口\n/fring toggle — 显示或隐藏",
	INFO_SITE = "网站",
	INFO_DISCORD = "Discord",
	INFO_COPY = "复制",
	INFO_COPIED = "链接已放入聊天输入框。按 Ctrl+C 复制。",
	HELP = "/fring options | toggle",
	LOCKED = "已开启。",
	UNLOCKED = "已关闭。",
	MINIMAP_L = "左键：选项",
	MINIMAP_R = "右键：显示或隐藏圆环。拖动可移动。",
	OPT_MINIMAP = "显示小地图按钮",
	OPT_LANG = "语言",
}

L.zhTW = {
	TITLE_SUB = "(Multi language)",
	INIT = "已載入。/fring options",
	OPTIONS_TITLE = "Forever Ring — 選項",
	TAB_RING = "圓環",
	TAB_INFO = "資訊",
	OPT_CARD_CURSOR = "滑鼠圓環",
	OPT_CARD_CAST = "施法",
	OPT_CARD_RANGE = "目標距離",
	OPT_CARD_ABOUT = "關於",
	OPT_CARD_COMMANDS = "指令",
	OPT_CARD_LINKS = "連結",
	OPT_ENABLE_RING = "顯示滑鼠圓環",
	OPT_ENABLE_CAST = "在圓環上顯示施法",
	OPT_ENABLE_RANGE = "在圓環外顯示距離",
	OPT_RANGE_TEXT = "顯示碼數",
	OPT_ONLY_COMBAT = "僅在戰鬥中",
	OPT_ONLY_ENEMY = "僅敵對目標",
	OPT_OUT_OF_COMBAT = "非戰鬥時顯示",
	OPT_RING_SIZE = "圓環大小：%d",
	OPT_RANGE_GAP = "距離環間距：%d",
	OPT_CLASS_COLOR = "使用職業顏色",
	OPT_RING_COLOR = "圓環顏色",
	OPT_RESET_CLASS = "職業",
	INFO_ABOUT = "Forever Ring 在滑鼠上畫一個圓環，並用外圈顯示目標距離。它不會施法。",
	INFO_ABOUT_POINTS = "• 滑鼠圓環，外圈顯示距離\n• 圓環上顯示施法進度\n• 介面支援 11 種語言 — 預設英語",
	INFO_CREDIT = "由 Vohnka 製作",
	INFO_SUPPORT = "僅在 Discord 以英語提供支援（#support、#bugs、#suggestions）。",
	INFO_CMD_HINT = "斜線指令 — 也可用 /foreverring：",
	INFO_CMD_LIST = "/fring — 說明\n/fring options — 本視窗\n/fring toggle — 顯示或隱藏",
	INFO_SITE = "網站",
	INFO_DISCORD = "Discord",
	INFO_COPY = "複製",
	INFO_COPIED = "連結已放入聊天輸入框。按 Ctrl+C 複製。",
	HELP = "/fring options | toggle",
	LOCKED = "已開啟。",
	UNLOCKED = "已關閉。",
	MINIMAP_L = "左鍵：選項",
	MINIMAP_R = "右鍵：顯示或隱藏圓環。拖曳可移動。",
	OPT_MINIMAP = "顯示小地圖按鈕",
	OPT_LANG = "語言",
}

L.ptBR = {
	TITLE_SUB = "(Multi language)",
	INIT = "Carregado. /fring options",
	OPTIONS_TITLE = "Forever Ring — Opções",
	TAB_RING = "Anel",
	TAB_INFO = "Info",
	OPT_CARD_CURSOR = "Anel do cursor",
	OPT_CARD_CAST = "Lançamento",
	OPT_CARD_RANGE = "Alcance do alvo",
	OPT_CARD_ABOUT = "Sobre",
	OPT_CARD_COMMANDS = "Comandos",
	OPT_CARD_LINKS = "Links",
	OPT_ENABLE_RING = "Mostrar o anel do cursor",
	OPT_ENABLE_CAST = "Mostrar o lançamento no anel",
	OPT_ENABLE_RANGE = "Mostrar o alcance ao redor do anel",
	OPT_RANGE_TEXT = "Mostrar jardas",
	OPT_ONLY_COMBAT = "Somente em combate",
	OPT_ONLY_ENEMY = "Somente alvos hostis",
	OPT_OUT_OF_COMBAT = "Mostrar fora de combate",
	OPT_RING_SIZE = "Tamanho do anel: %d",
	OPT_RANGE_GAP = "Espaço do anel de alcance: %d",
	OPT_CLASS_COLOR = "Usar cor da classe",
	OPT_RING_COLOR = "Cor do anel",
	OPT_RESET_CLASS = "Classe",
	INFO_ABOUT = "Forever Ring desenha um anel no mouse e um segundo círculo com a distância do alvo. Ele nunca lança feitiços.",
	INFO_ABOUT_POINTS = "• Anel no cursor, círculo de alcance ao redor\n• Progresso do lançamento no anel\n• Interface em 11 idiomas — inglês como reserva",
	INFO_CREDIT = "Criado por Vohnka",
	INFO_SUPPORT = "O suporte é só no Discord, em inglês (#support, #bugs, #suggestions).",
	INFO_CMD_HINT = "Comandos — também /foreverring:",
	INFO_CMD_LIST = "/fring — ajuda\n/fring options — esta janela\n/fring toggle — mostrar ou ocultar",
	INFO_SITE = "Site",
	INFO_DISCORD = "Discord",
	INFO_COPY = "Copiar",
	INFO_COPIED = "O link está na caixa de chat. Ctrl+C para copiar.",
	HELP = "/fring options | toggle",
	LOCKED = "Ligado.",
	UNLOCKED = "Desligado.",
	MINIMAP_L = "Clique esquerdo: opções",
	MINIMAP_R = "Clique direito: mostrar ou ocultar os anéis. Arraste para mover.",
	OPT_MINIMAP = "Mostrar botão do minimapa",
	OPT_LANG = "Idioma",
}

L.itIT = {
	TITLE_SUB = "(Multi language)",
	INIT = "Caricato. /fring options",
	OPTIONS_TITLE = "Forever Ring — Opzioni",
	TAB_RING = "Anello",
	TAB_INFO = "Info",
	OPT_CARD_CURSOR = "Anello del cursore",
	OPT_CARD_CAST = "Lancio",
	OPT_CARD_RANGE = "Portata del bersaglio",
	OPT_CARD_ABOUT = "Informazioni",
	OPT_CARD_COMMANDS = "Comandi",
	OPT_CARD_LINKS = "Link",
	OPT_ENABLE_RING = "Mostra l'anello del cursore",
	OPT_ENABLE_CAST = "Mostra il lancio sull'anello",
	OPT_ENABLE_RANGE = "Mostra la portata intorno all'anello",
	OPT_RANGE_TEXT = "Mostra le iarde",
	OPT_ONLY_COMBAT = "Solo in combattimento",
	OPT_ONLY_ENEMY = "Solo bersagli ostili",
	OPT_OUT_OF_COMBAT = "Mostra fuori dal combattimento",
	OPT_RING_SIZE = "Dimensione dell'anello: %d",
	OPT_RANGE_GAP = "Distanza dell'anello di portata: %d",
	OPT_CLASS_COLOR = "Usa il colore della classe",
	OPT_RING_COLOR = "Colore dell'anello",
	OPT_RESET_CLASS = "Classe",
	INFO_ABOUT = "Forever Ring disegna un anello sul mouse e un secondo cerchio per la distanza dal bersaglio. Non lancia mai.",
	INFO_ABOUT_POINTS = "• Anello sul cursore, cerchio di portata intorno\n• Progresso del lancio sull'anello\n• Interfaccia in 11 lingue — inglese come riserva",
	INFO_CREDIT = "Creato da Vohnka",
	INFO_SUPPORT = "Il supporto è solo su Discord, in inglese (#support, #bugs, #suggestions).",
	INFO_CMD_HINT = "Comandi — anche /foreverring:",
	INFO_CMD_LIST = "/fring — aiuto\n/fring options — questa finestra\n/fring toggle — mostra o nascondi",
	INFO_SITE = "Sito",
	INFO_DISCORD = "Discord",
	INFO_COPY = "Copia",
	INFO_COPIED = "Il link è nella casella della chat. Ctrl+C per copiare.",
	HELP = "/fring options | toggle",
	LOCKED = "Attivo.",
	UNLOCKED = "Disattivo.",
	MINIMAP_L = "Clic sinistro: opzioni",
	MINIMAP_R = "Clic destro: mostra o nascondi gli anelli. Trascina per spostare.",
	OPT_MINIMAP = "Mostra il pulsante della minimappa",
	OPT_LANG = "Lingua",
}

L.koKR = {
	TITLE_SUB = "(Multi language)",
	INIT = "로드됨. /fring options",
	OPTIONS_TITLE = "Forever Ring — 설정",
	TAB_RING = "고리",
	TAB_INFO = "정보",
	OPT_CARD_CURSOR = "커서 고리",
	OPT_CARD_CAST = "시전",
	OPT_CARD_RANGE = "대상 거리",
	OPT_CARD_ABOUT = "정보",
	OPT_CARD_COMMANDS = "명령",
	OPT_CARD_LINKS = "링크",
	OPT_ENABLE_RING = "커서 고리 표시",
	OPT_ENABLE_CAST = "고리에 시전 표시",
	OPT_ENABLE_RANGE = "고리 주변에 거리 표시",
	OPT_RANGE_TEXT = "야드 숫자 표시",
	OPT_ONLY_COMBAT = "전투 중에만",
	OPT_ONLY_ENEMY = "적대 대상만",
	OPT_OUT_OF_COMBAT = "비전투 시에도 표시",
	OPT_RING_SIZE = "고리 크기: %d",
	OPT_RANGE_GAP = "거리 고리 간격: %d",
	OPT_CLASS_COLOR = "직업 색상 사용",
	OPT_RING_COLOR = "고리 색상",
	OPT_RESET_CLASS = "직업",
	INFO_ABOUT = "Forever Ring은 마우스에 고리를 그리고, 그 바깥 원으로 대상 거리를 표시합니다. 직접 시전하지 않습니다.",
	INFO_ABOUT_POINTS = "• 커서 고리, 주변에 거리 원\n• 고리에 시전 진행도\n• 11개 언어 인터페이스 — 영어 대체",
	INFO_CREDIT = "제작: Vohnka",
	INFO_SUPPORT = "지원은 Discord에서만, 영어로 받습니다(#support, #bugs, #suggestions).",
	INFO_CMD_HINT = "슬래시 명령 — /foreverring 도 가능:",
	INFO_CMD_LIST = "/fring — 도움말\n/fring options — 이 창\n/fring toggle — 표시 또는 숨기기",
	INFO_SITE = "웹사이트",
	INFO_DISCORD = "Discord",
	INFO_COPY = "복사",
	INFO_COPIED = "링크가 채팅창에 있습니다. Ctrl+C로 복사하세요.",
	HELP = "/fring options | toggle",
	LOCKED = "켜짐.",
	UNLOCKED = "꺼짐.",
	MINIMAP_L = "왼쪽 클릭: 설정",
	MINIMAP_R = "오른쪽 클릭: 고리 표시 또는 숨기기. 드래그하여 이동.",
	OPT_MINIMAP = "미니맵 버튼 표시",
	OPT_LANG = "언어",
}

local function withFallback(map)
	return setmetatable(map, {
		__index = function(_, key)
			return L.enUS[key]
		end,
	})
end

local packs = {
	enUS = L.enUS,
	frFR = withFallback(L.frFR),
	deDE = withFallback(L.deDE),
	esES = withFallback(L.esES),
	esMX = withFallback(L.esES),
	ruRU = withFallback(L.ruRU),
	zhCN = withFallback(L.zhCN),
	zhTW = withFallback(L.zhTW),
	ptBR = withFallback(L.ptBR),
	itIT = withFallback(L.itIT),
	koKR = withFallback(L.koKR),
}

local ORDER = { "auto", "enUS", "frFR", "deDE", "esES", "ruRU", "zhCN", "zhTW", "ptBR", "itIT", "koKR" }
local NAMES = {
	auto = "Auto",
	enUS = "English",
	enGB = "English",
	frFR = "Français",
	deDE = "Deutsch",
	esES = "Español",
	esMX = "Español",
	ruRU = "Русский",
	zhCN = "简体中文",
	zhTW = "繁體中文",
	ptBR = "Português",
	itIT = "Italiano",
	koKR = "한국어",
}

function ns.ClientLocale()
	local ok, loc = pcall(GetLocale)
	loc = (ok and loc) or "enUS"
	if loc == "enGB" then
		return "enUS"
	end
	return loc
end

local function resolveLocale(choice)
	if choice == nil or choice == "" or choice == "auto" then
		choice = ns.ClientLocale()
	end
	if choice == "enGB" then
		choice = "enUS"
	end
	if choice == "esMX" then
		choice = "esES"
	end
	if not packs[choice] then
		choice = "enUS"
	end
	return choice
end

function ns.ActiveLocale()
	local choice = ns.db and ns.db.locale
	return resolveLocale(choice)
end

function ns.LocaleLabel(code)
	code = code or (ns.db and ns.db.locale) or "auto"
	if code == "" then
		code = "auto"
	end
	if code == "auto" then
		local client = NAMES[ns.ClientLocale()] or ns.ClientLocale()
		return "Auto (" .. client .. ")"
	end
	return NAMES[code] or code
end

function ns.CycleLocale()
	if not ns.db then
		return
	end
	local cur = ns.db.locale
	if cur == nil or cur == "" then
		cur = "auto"
	end
	local idx = 1
	for i, code in ipairs(ORDER) do
		if code == cur then
			idx = i
			break
		end
	end
	ns.db.locale = ORDER[(idx % #ORDER) + 1]
	if ns.RelocalizeOptions then
		ns.RelocalizeOptions()
	end
end

function ns.T(key)
	local pack = packs[ns.ActiveLocale()] or L.enUS
	return pack[key] or L.enUS[key] or key
end
