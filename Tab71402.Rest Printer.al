OBJECT Table 21001402 _Принтер Место
{
  OBJECT-PROPERTIES
  {
    Date=13.05.21;
    Time=13:13:56;
    Modified=Yes;
    Version List=KRF,PPC,mod;
  }
  PROPERTIES
  {
    DataPerCompany=No;
    LookupFormID=Form50073;
  }
  FIELDS
  {
    { 1   ;   ;Код Места           ;Code20         }
    { 50001;  ;Код Зала            ;Code10        ;TableRelation="KR Hall" }
    { 50002;  ;Код Компьютера      ;Code20         }
    { 50003;  ;LDN                 ;Text30         }
    { 50004;  ;Выключен            ;Boolean        }
    { 50006;  ;Наличие Слипа       ;Boolean        }
    { 50007;  ;Кодовая Страница    ;Integer        }
    { 50008;  ;IP Сервера Печати   ;Text30         }
    { 50009;  ;Номер Сервера Печати;Integer        }
    { 50010;  ;Длина Строки        ;Integer        }
    { 50011;  ;Длина Строки Слипа  ;Integer        }
    { 50012;  ;Колво Строк Слипа   ;Integer        }
    { 50013;  ;Отступ Сверху       ;Integer        }
    { 50014;  ;Отступ Снизу        ;Integer        }
    { 50015;  ;Slip STAR mode      ;Boolean        }
    { 50016;  ;Описание Места      ;Text60         }
    { 50017;  ;Номер               ;Integer        }
    { 50018;  ;Номер Заместителя   ;Integer        }
    { 50019;  ;Код места для PPC   ;Code20        ;TableRelation="_Принтер Место"."Код Места";
                                                   Description=PocketPC выделенный принтер }
    { 50020;  ;КодМестаАльт        ;Code100       ;Description=PocketPC Альтерн. принтер }
    { 50021;  ;Печать предчека на ТП;Boolean      ;CaptionML=RUS=Печать пречека на ТП }
    { 50022;  ;Звонок Есть         ;Boolean        }
    { 50023;  ;Количество Слипов   ;Integer        }
    { 50024;  ;Print On FR         ;Boolean       ;CaptionML=[ENU=Print On FR;
                                                              RUS=Печатать пречека на ФР] }
  }
  KEYS
  {
    {    ;Код Места,Код Зала,Код Компьютера,LDN   ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    BEGIN
    END.
  }
}

