OBJECT Table 21001405 _����࠭ ��㯯�
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
               _recRight.SETRANGE("��� ��㯯�", ���);
               _recRight.DELETEALL;
             END;

    LookupFormID=Form21001407;
    DrillDownFormID=Form21001407;
  }
  FIELDS
  {
    { 1   ;   ;���                 ;Code10         }
    { 2   ;   ;��������            ;Text30         }
    { 3   ;   ;�������� 2          ;Text30         }
    { 50001;  ;���ᨬ��쭠� ������%;Decimal        }
    { 50002;  ;����� ��            ;Boolean       ;Description=� ���� ⮫쪮 ����. ����� }
  }
  KEYS
  {
    {    ;���                                     ;Clustered=Yes }
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

