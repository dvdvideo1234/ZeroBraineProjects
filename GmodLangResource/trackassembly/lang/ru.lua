﻿return function(sTool, sLimit) local tSet = {} -- Russian
  tSet["tool."..sTool..".workmode.1"    ] = "Общее создание/прилепание куски"
  tSet["tool."..sTool..".workmode.2"    ] = "Пересечение активной точки"
  tSet["tool."..sTool..".workmode.3"    ] = "Кривой отрезок линии фитинг"
  tSet["tool."..sTool..".workmode.4"    ] = "Нормаль поверхности перевернуть"
  tSet["tool."..sTool..".desc"          ] = "Создает дорогу для транспортных средств"
  tSet["tool."..sTool..".name"          ] = "Сборка дороги"
  tSet["tool."..sTool..".phytype"       ] = "Выберите тип физических свойств из тех которые перечислены здесь"
  tSet["tool."..sTool..".phytype_con"   ] = "Тип поверхности:"
  tSet["tool."..sTool..".phytype_def"   ] = "<Выберите ТИП поверхности>"
  tSet["tool."..sTool..".phyname"       ] = "Выберите имя физических свойств которые могут быть использованы при создании дороги так как это повлияет на поверхностное трение"
  tSet["tool."..sTool..".phyname_con"   ] = "Имя поверхности:"
  tSet["tool."..sTool..".phyname_def"   ] = "<Выберите ИМЯ поверхности>"
  tSet["tool."..sTool..".bgskids"       ] = "Код выбора через запятую для Группа-тела/Кожа ID"
  tSet["tool."..sTool..".bgskids_con"   ] = "Группа-тела/Кожа:"
  tSet["tool."..sTool..".bgskids_def"   ] = "Написать код выбора здесь. Например 1,0,0,2,1/3"
  tSet["tool."..sTool..".mass"          ] = "Как тяжелый кусок создал будет"
  tSet["tool."..sTool..".mass_con"      ] = "Масса куска:"
  tSet["tool."..sTool..".model"         ] = "Выберите кусок чтобы начать/продолжить свою дорогу выбирая тип дерева и нажав на листе"
  tSet["tool."..sTool..".model_con"     ] = "Модель куска:"
  tSet["tool."..sTool..".activrad"      ] = "Минимальное расстояние чтобы выбрать активную точку"
  tSet["tool."..sTool..".activrad_con"  ] = "Активный радиус:"
  tSet["tool."..sTool..".stackcnt"      ] = "Максимальное количество куски для нагромождения"
  tSet["tool."..sTool..".stackcnt_con"  ] = "Количество кусков:"
  tSet["tool."..sTool..".angsnap"       ] = "Приклейте первый кусок созданный тем положением градусов"
  tSet["tool."..sTool..".angsnap_con"   ] = "Угловое выравнивание:"
  tSet["tool."..sTool..".resetvars"     ] = "Нажмите чтобы сбросить дополнительные значения"
  tSet["tool."..sTool..".resetvars_con" ] = "V Сбросить переменные V"
  tSet["tool."..sTool..".nextpic"       ] = "Дополнительный сдвиг начала тангажом"
  tSet["tool."..sTool..".nextpic_con"   ] = "Начало тангажа:"
  tSet["tool."..sTool..".nextyaw"       ] = "Дополнительный сдвиг начала рысканием"
  tSet["tool."..sTool..".nextyaw_con"   ] = "Начало рыскания:"
  tSet["tool."..sTool..".nextrol"       ] = "Дополнительный сдвиг начала рулона"
  tSet["tool."..sTool..".nextrol_con"   ] = "Начало рулона:"
  tSet["tool."..sTool..".nextx"         ] = "Дополнительное линейное смещение X"
  tSet["tool."..sTool..".nextx_con"     ] = "Смещения X:"
  tSet["tool."..sTool..".nexty"         ] = "Дополнительное линейное смещение Y"
  tSet["tool."..sTool..".nexty_con"     ] = "Смещения Y:"
  tSet["tool."..sTool..".nextz"         ] = "Дополнительное линейное смещение Z"
  tSet["tool."..sTool..".nextz_con"     ] = "Смещения Z:"
  tSet["tool."..sTool..".gravity"       ] = "Управляет гравитацию куска"
  tSet["tool."..sTool..".gravity_con"   ] = "Применить силу тяжести к куске"
  tSet["tool."..sTool..".weld"          ] = "Создает сварные швы между кусками или кусоком/якорем"
  tSet["tool."..sTool..".weld_con"      ] = "Сварной шов"
  tSet["tool."..sTool..".forcelim"      ] = "Управляет сколько сил требуется чтобы сломать сварной шов"
  tSet["tool."..sTool..".forcelim_con"  ] = "Ограничение силы:"
  tSet["tool."..sTool..".ignphysgn"     ] = "Игнорирует захвата физической пушки при созданием/приклеиванием/нагромождением куска"
  tSet["tool."..sTool..".ignphysgn_con" ] = "Игнорирует захвата физической пушки"
  tSet["tool."..sTool..".nocollide"     ] = "Делает не-столкновение между кусками или кусоком/якорем"
  tSet["tool."..sTool..".nocollide_con" ] = "Не-столкновение"
  tSet["tool."..sTool..".nocollidew"    ] = "Делает не-столкновение между кусками и миром"
  tSet["tool."..sTool..".nocollidew_con"] = "Не-столкновение миром"
  tSet["tool."..sTool..".freeze"        ] = "Создает заморожений кусок"
  tSet["tool."..sTool..".freeze_con"    ] = "Заморозить кусок"
  tSet["tool."..sTool..".igntype"       ] = "Игнорирует различные типы кусков прилипания/накопления"
  tSet["tool."..sTool..".igntype_con"   ] = "Игнорировать тип кусков"
  tSet["tool."..sTool..".spnflat"       ] = "Следующий кусок будет создан/приклеен/накоплен по горизонтали"
  tSet["tool."..sTool..".spnflat_con"   ] = "Нагромождать по горизонтали"
  tSet["tool."..sTool..".spawncn"       ] = "Создание куска в центре иначе в выбранной активной точке"
  tSet["tool."..sTool..".spawncn_con"   ] = "Происхождение из центра"
  tSet["tool."..sTool..".surfsnap"      ] = "Приклеить кусок к поверхности к которой ссылается пользователь"
  tSet["tool."..sTool..".surfsnap_con"  ] = "Приклеивать к поверхности"
  tSet["tool."..sTool..".appangfst"     ] = "Применять угловое смещение только на первой кусок"
  tSet["tool."..sTool..".appangfst_con" ] = "Применять угловое на первой"
  tSet["tool."..sTool..".applinfst"     ] = "Применять линейное смещение только на первой кусок"
  tSet["tool."..sTool..".applinfst_con" ] = "Применять линейное на первой"
  tSet["tool."..sTool..".adviser"       ] = "Управляет отображением позиционного/углового советника"
  tSet["tool."..sTool..".adviser_con"   ] = "Нарисовать советник"
  tSet["tool."..sTool..".pntasist"      ] = "Управляет изображение помощника для прилипания"
  tSet["tool."..sTool..".pntasist_con"  ] = "Нарисовать помощника"
  tSet["tool."..sTool..".ghostcnt"      ] = "Управляет подсчет отображением куска-тени"
  tSet["tool."..sTool..".ghostcnt_con"  ] = "Нарисовать подсчет кусок-тень"
  tSet["tool."..sTool..".engunsnap"     ] = "Управляет приклеивание когда кусок выпущен физической пушки пользователя"
  tSet["tool."..sTool..".engunsnap_con" ] = "Приклеивать выпуском"
  tSet["tool."..sTool..".upspanchor"    ] = "Включите якорь обновить для каждый раз когда создаете без накопления"
  tSet["tool."..sTool..".upspanchor_con"] = "Обновить якорь при создаване"
  tSet["tool."..sTool..".type"          ] = "Выберите типа дороги для использования путем расширения папки"
  tSet["tool."..sTool..".type_con"      ] = "Тип дороги:"
  tSet["tool."..sTool..".subfolder"     ] = "Выберите категорию дороги для использования путем расширения папки"
  tSet["tool."..sTool..".subfolder_con" ] = "Категория дороги:"
  tSet["tool."..sTool..".workmode"      ] = "Измените эту опцию чтобы использовать другой рабочий режим"
  tSet["tool."..sTool..".workmode_con"  ] = "Рабочий режим:"
  tSet["tool."..sTool..".pn_export"     ] = "Нажмите чтобы сохранить файл базы данных"
  tSet["tool."..sTool..".pn_export_lb"  ] = "Экспорт БД"
  tSet["tool."..sTool..".pn_routine"    ] = "Список регулярно используемых кусков дороги"
  tSet["tool."..sTool..".pn_routine_hd" ] = "Часто используемых кусков пользователя:"
  tSet["tool."..sTool..".pn_externdb"   ] = "Внешние базы данных доступные для:"
  tSet["tool."..sTool..".pn_externdb_hd"] = "Внешние базы данных для:"
  tSet["tool."..sTool..".pn_externdb_lb"] = "Нажмите правой для вариантов:"
  tSet["tool."..sTool..".pn_externdb_1" ] = "Скопировать префикс"
  tSet["tool."..sTool..".pn_externdb_2" ] = "Скопировать път папку DSV"
  tSet["tool."..sTool..".pn_externdb_3" ] = "Скопировать ник таблицу"
  tSet["tool."..sTool..".pn_externdb_4" ] = "Скопировать път таблицу"
  tSet["tool."..sTool..".pn_externdb_5" ] = "Скопировать время таблицу"
  tSet["tool."..sTool..".pn_externdb_6" ] = "Скопировать размер таблицу"
  tSet["tool."..sTool..".pn_externdb_7" ] = "Изменить элементы (Luapad)"
  tSet["tool."..sTool..".pn_externdb_8" ] = "Удалить файл базы данных"
  tSet["tool."..sTool..".pn_ext_dsv_lb" ] = "Внешний список DSV"
  tSet["tool."..sTool..".pn_ext_dsv_hd" ] = "Список внешних баз данных DSV отображается здесь"
  tSet["tool."..sTool..".pn_ext_dsv_1"  ] = "Уникальный префикс базы данных"
  tSet["tool."..sTool..".pn_ext_dsv_2"  ] = "Активный"
  tSet["tool."..sTool..".pn_display"    ] = "Модель вашего куска дороги здесь отображается"
  tSet["tool."..sTool..".pn_pattern"    ] = "Напишите шаблон здесь и нажмите ВВОД для выполнения поиска"
  tSet["tool."..sTool..".pn_srchcol"    ] = "Выберите столбец для поиска"
  tSet["tool."..sTool..".pn_srchcol_lb" ] = "<Искать по>"
  tSet["tool."..sTool..".pn_srchcol_lb1"] = "Модель"
  tSet["tool."..sTool..".pn_srchcol_lb2"] = "Тип"
  tSet["tool."..sTool..".pn_srchcol_lb3"] = "Имя"
  tSet["tool."..sTool..".pn_srchcol_lb4"] = "Конец"
  tSet["tool."..sTool..".pn_routine_lb" ] = "Часто используемых кусков"
  tSet["tool."..sTool..".pn_routine_lb1"] = "Срок"
  tSet["tool."..sTool..".pn_routine_lb2"] = "Конец"
  tSet["tool."..sTool..".pn_routine_lb3"] = "Тип"
  tSet["tool."..sTool..".pn_routine_lb4"] = "Имя"
  tSet["tool."..sTool..".pn_display_lb" ] = "Показать кусок"
  tSet["tool."..sTool..".pn_pattern_lb" ] = "Напишите шаблон"
  tSet["Cleanup_"..sLimit               ] = "Собранные куски дороги"
  tSet["Cleaned_"..sLimit               ] = "Все куски дороги очищены"
  tSet["SBoxLimit_"..sLimit             ] = "Вы достигли предела созданных кусков дороги!"
return tSet end