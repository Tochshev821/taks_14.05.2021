OBJECT Table 21001402 _�ਭ�� ����
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
    { 1   ;   ;��� ����           ;Code20         }
    { 50001;  ;��� ����            ;Code10        ;TableRelation="KR Hall" }
    { 50002;  ;��� ��������      ;Code20         }
    { 50003;  ;LDN                 ;Text30         }
    { 50004;  ;�몫�祭            ;Boolean        }
    { 50006;  ;����稥 �����       ;Boolean        }
    { 50007;  ;������� ��࠭��    ;Integer        }
    { 50008;  ;IP ��ࢥ� ����   ;Text30         }
    { 50009;  ;����� ��ࢥ� ����;Integer        }
    { 50010;  ;����� ��ப�        ;Integer        }
    { 50011;  ;����� ��ப� �����  ;Integer        }
    { 50012;  ;����� ��ப �����   ;Integer        }
    { 50013;  ;����� ������       ;Integer        }
    { 50014;  ;����� �����        ;Integer        }
    { 50015;  ;Slip STAR mode      ;Boolean        }
    { 50016;  ;���ᠭ�� ����      ;Text60         }
    { 50017;  ;�����               ;Integer        }
    { 50018;  ;����� ������⥫�   ;Integer        }
    { 50019;  ;��� ���� ��� PPC   ;Code20        ;TableRelation="_�ਭ�� ����"."��� ����";
                                                   Description=PocketPC �뤥����� �ਭ�� }
    { 50020;  ;������⠀���        ;Code100       ;Description=PocketPC �����. �ਭ�� }
    { 50021;  ;����� �।祪� �� ��;Boolean      ;CaptionML=RUS=����� ��祪� �� �� }
    { 50022;  ;������ ����         ;Boolean        }
    { 50023;  ;������⢮ ������   ;Integer        }
    { 50024;  ;Print On FR         ;Boolean       ;CaptionML=[ENU=Print On FR;
                                                              RUS=������ ��祪� �� ��] }
  }
  KEYS
  {
    {    ;��� ����,��� ����,��� ��������,LDN   ;Clustered=Yes }
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

