OBJECT Table 21001408 KR Group Rights
{
  OBJECT-PROPERTIES
  {
    Date=13.11.14;
    Time=17:28:31;
    Modified=Yes;
    Version List=KRF,BC+;
  }
  PROPERTIES
  {
    DataPerCompany=No;
    CaptionML=RUS="Группа права доступа ";
    LookupFormID=Form21001410;
    DrillDownFormID=Form21001410;
  }
  FIELDS
  {
    { 1   ;   ;Код Группы          ;Code10        ;TableRelation="_Ресторан Группы" }
    { 2   ;   ;Код Действия        ;Code10        ;TableRelation="KR Access Rights";
                                                   OnValidate=BEGIN

                                                                РесторанДействия.RESET;
                                                                РесторанДействия.SETRANGE(Код,"Код Действия");
                                                                IF РесторанДействия.FIND('-') THEN
                                                                BEGIN
                                                                  Название := РесторанДействия.Название;
                                                                  "Название 2" := РесторанДействия."Название 2";

                                                                END;
                                                              END;
                                                               }
    { 3   ;   ;Название            ;Text30         }
    { 4   ;   ;Название 2          ;Text30         }
    { 5   ;   ;Код Группировки     ;Code10         }
    { 50001;  ;Право на Действие   ;Boolean       ;CaptionML=RUS=Разрешено }
    { 50002;  ;Право на Подпись    ;Boolean       ;CaptionML=RUS=Не требовать подтверждение }
    { 50003;  ;Group Name          ;Text30        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("_Ресторан Группы".Название WHERE (Код=FIELD(Код Группы)));
                                                   CaptionML=RUS=Название Группы }
  }
  KEYS
  {
    {    ;Код Группы,Код Действия                 ;Clustered=Yes }
    {    ;Код Группировки,Код Действия             }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      РесторанДействия@1000000000 : Record 21001407;

    BEGIN
    END.
  }
}

