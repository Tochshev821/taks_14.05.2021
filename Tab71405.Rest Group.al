OBJECT Table 21001405 _Ресторан Группы
{
  OBJECT-PROPERTIES
  {
    Date=18.12.18;
    Time=10:09:39;
    Modified=Yes;
    Version List=KRF,BC+;
  }
  PROPERTIES
  {
    DataPerCompany=No;
    OnDelete=VAR
               _recRight@1000000000 : Record 21001408;
             BEGIN
               _recRight.SETRANGE("Код Группы", Код);
               _recRight.DELETEALL;
             END;

    LookupFormID=Form21001407;
    DrillDownFormID=Form21001407;
  }
  FIELDS
  {
    { 1   ;   ;Код                 ;Code10         }
    { 2   ;   ;Название            ;Text30         }
    { 3   ;   ;Название 2          ;Text30         }
    { 50001;  ;Максимальная Скидка%;Decimal        }
    { 50002;  ;Режим ФФ            ;Boolean       ;Description=в расчете только Экспр. оплата }
  }
  KEYS
  {
    {    ;Код                                     ;Clustered=Yes }
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

