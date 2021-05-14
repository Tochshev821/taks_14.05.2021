OBJECT Table 21001400 �������� ����࠭� ����ன��
{
  OBJECT-PROPERTIES
  {
    Date=15.01.19;
    Time=12:06:25;
    Modified=Yes;
    Version List=KRF,res,CK;
  }
  PROPERTIES
  {
    DataPerCompany=No;
  }
  FIELDS
  {
    { 1   ;   ;����                ;Code10        ;TableRelation="KR Hall" }
    { 2   ;   ;����㤭�� ����࠭� ���� ��.;Code20;
                                                   TableRelation="No. Series" }
    { 3   ;   ;�� �����            ;Boolean        }
    { 4   ;   ;�� RKeeper          ;Boolean        }
    { 5   ;   ;��� ��।�� ������ ;Option        ;OptionString=��१ �஬������ ������� NF,������� � ������� �� }
    { 6   ;   ;�������. ��⠭�� ���� ����஢;Code20;
                                                   TableRelation="No. Series" }
    { 7   ;   ;��� �������樨 ���ᮭ���;Option   ;OptionString=���,����,���� }
    { 8   ;   ;�।�. ����� ����. ���� ��.;Code20;TableRelation="No. Series" }
    { 9   ;   ;��� ����७�� ��� �����. ���;Code20;
                                                   TableRelation=Item }
    { 10  ;   ;������� ����� �� ������ ��६;Boolean }
    { 11  ;   ;������. ���� ����� �� ����.;Boolean }
    { 13  ;   ;���. ��ୠ� ��� �������;Code10     ;TableRelation="Gen. Journal Template".Name }
    { 14  ;   ;���. ��ୠ� ��� ������;Code10      ;TableRelation="Gen. Journal Batch".Name WHERE (Journal Template Name=FIELD(���. ��ୠ� ��� �������)) }
    { 15  ;   ;�஢����� �� ��壠��ਨ;Option    ;OptionString=�㬬�୮,�� �⤥��� � �஥�⠬ }
    { 18  ;   ;������ ����࠭� ���� ����஢;Code20;
                                                   TableRelation="No. Series" }
    { 19  ;   ;���� ����࠭�     ;Code10        ;TableRelation="Bank Account".No. }
    { 20  ;   ;��� �������樨 �����;Option       ;OptionString=���,���� }
    { 21  ;   ;��� ����� � ���  ;Option        ;OptionString=��� ��ਠ�⮢,� ��ਠ�⠬� }
    { 22  ;   ;��� ��।�� � ��� �����;Option   ;OptionString=�� ������ �������,�� ������ �஭�஢���� }
    { 24  ;   ;��� ��.            ;Code10        ;TableRelation="No. Series" }
    { 25  ;   ;���. ��� ��.       ;Code10        ;TableRelation="No. Series" }
    { 26  ;   ;��� �㬬�஢����    ;Option        ;OptionString=[ ,�� ���] }
    { 27  ;   ;���� ���筨�       ;Boolean        }
    { 28  ;   ;�������� ����࠭�  ;Text5          }
    { 29  ;   ;��ନ஢. ����� ��㣠 ��ப�;Boolean }
    { 51  ;   ;���. ��ୠ� ��� ������� �����;Code10;
                                                   TableRelation="Gen. Journal Template".Name }
    { 52  ;   ;���. ��ୠ� ��� ������ �����;Code10;TableRelation="Gen. Journal Batch".Name WHERE (Journal Template Name=FIELD(���. ��ୠ� ��� ������� �����)) }
    { 53  ;   ;����� ���⠢騪 ��. ;Code20        ;TableRelation=Vendor }
    { 54  ;   ;����� ��⭠� ��㯯�;Code20        ;TableRelation="Vendor Posting Group".Code }
    { 50000;  ;�।. ���� ����   ;Code20        ;CaptionML=RUS=�।. ����� ����� }
    { 50001;  ;�।. ���� ���� (����. ���);Code20;
                                                   CaptionML=RUS=�।. ����� ����� (Am.Exp.) }
    { 50002;  ;����窠 ������ ��砫�;Integer     }
    { 50003;  ;����窠 ������ ����砭��;Integer  }
    { 50004;  ;���. ����. ������ ��砫�;Integer  }
    { 50005;  ;���. ����. ������ ����砭��;Integer }
    { 50006;  ;�������� ����࠭� ���;Code5       ;TableRelation="_����㤭�� ����࠭�";
                                                   OnValidate=BEGIN

                                                                ����㤭������࠭�.RESET;
                                                                ����㤭������࠭�.SETRANGE(����㤭������࠭�."��.","�������� ����࠭� ���");
                                                                IF ����㤭������࠭�.FIND('-') THEN
                                                                  "�������� ����࠭�" := ����㤭������࠭�.������� + ' ' + ����㤭������࠭�.���樠��;
                                                              END;
                                                               }
    { 50007;  ;��� ��।. �஥�. �த��� ���;Option;
                                                   OptionString=�� �஥��� ����,�� �஥��� ��� }
    { 50018;  ;������ ������ ���� ����஢;Code20 ;TableRelation="No. Series" }
    { 50019;  ;���� �����ঠ     ;Code10        ;TableRelation="Bank Account".No. }
    { 50024;  ;��� ��. ������.    ;Code10        ;TableRelation="No. Series" }
    { 50025;  ;���. ��� ��. ������.;Code10       ;TableRelation="No. Series" }
    { 50026;  ;�� ���쪮 �� ����;Boolean        }
    { 50027;  ;�����䨪��� ���쪮 �� ����;Boolean }
    { 50029;  ;���. ������ �����⨥ �����;Boolean }
    { 50030;  ;���. ����� �����⨥ Z-ᬥ��;Boolean }
    { 50031;  ;���. Z-ᬥ�� �����⨥ ����;Boolean }
    { 50032;  ;���. ���� �����⨥ �।����;Boolean }
    { 50033;  ;�������� ��������   ;Text60         }
    { 50034;  ;���न���� ����祩 ��� X;Integer    }
    { 50035;  ;���न���� ����祩 ��� Y;Integer    }
    { 50036;  ;������ ࠡ�祩 ��� X;Integer        }
    { 50037;  ;������ ࠡ�祩 ��� Y;Integer        }
    { 50038;  ;Def PayMaster ������;Code10         }
    { 50039;  ;Def PayMaster G     ;Code10         }
    { 50040;  ;�࠭��� ���� ���ਧ�樨;Text10     }
    { 50041;  ;������ �� �������ࠬ ��ࢨ� �;Text250 }
    { 50042;  ;�६� ᤢ��� ���⭮��;Time       ;CaptionML=RUS=�६� ����� Z }
    { 50043;  ;������ �� �������ࠬ � ���.;Text250 }
    { 50044;  ;Shortcut Dimension 3 Code;Code20   ;TableRelation=Dimension;
                                                   CaptionML=[ENU=Shortcut Dimension 3 Code;
                                                              RUS=��� ��� ��ꥪ�] }
    { 50045;  ;Shortcut Dimension 8 Code;Code20   ;TableRelation=Dimension;
                                                   CaptionML=[ENU=Shortcut Dimension 3 Code;
                                                              RUS=��� ���� ��] }
    { 50046;  ;Dim8                ;Code20        ;TableRelation="Dimension Value".Code WHERE (Dimension Code=FIELD(Shortcut Dimension 8 Code));
                                                   CaptionML=RUS=���ᠫ. ��. }
    { 50047;  ;Shortcut Dimension 4 Code;Code20   ;TableRelation=Dimension;
                                                   CaptionML=[ENU=Shortcut Dimension 3 Code;
                                                              RUS=��� ����] }
    { 50048;  ;Dim4                ;Code20        ;TableRelation="Dimension Value".Code WHERE (Dimension Code=FIELD(Shortcut Dimension 4 Code));
                                                   CaptionML=RUS=����;
                                                   Description=yuri 210613 }
    { 50049;  ;Dim4Compl           ;Code20        ;TableRelation="Dimension Value".Code WHERE (Dimension Code=FIELD(Shortcut Dimension 4 Code));
                                                   CaptionML=RUS=���� COMPL;
                                                   Description=yuri 210613 }
    { 50050;  ;Dim4EPR             ;Code20        ;TableRelation="Dimension Value".Code WHERE (Dimension Code=FIELD(Shortcut Dimension 4 Code));
                                                   CaptionML=RUS=���� EPR;
                                                   Description=yuri 130314 }
    { 50051;  ;Dim4Breakfast       ;Code20        ;TableRelation="Dimension Value".Code WHERE (Dimension Code=FIELD(Shortcut Dimension 4 Code));
                                                   CaptionML=RUS=���� ����ࠪ;
                                                   Description=yuri 010714 }
    { 50052;  ;Man.Class.Openfood  ;Code100       ;TableRelation="�����䨪��� ��㯯�".��� WHERE (�ਭ������� ���=CONST(Yes));
                                                   ValidateTableRelation=No;
                                                   CaptionML=RUS=�����䨪��� ������ ���� }
    { 50053;  ;Path for Picture    ;Text250       ;CaptionML=RUS=���� ��� ���⨭��;
                                                   Description=yuri 211114 }
    { 50054;  ;Height for Picture  ;Integer       ;CaptionML=RUS=���� ���⨭��;
                                                   Description=yuri 211114 }
    { 50055;  ;Width for Picture   ;Integer       ;CaptionML=RUS=��ਭ� ���⨭��;
                                                   Description=yuri 211114 }
    { 50056;  ;Temp Picture        ;BLOB          ;CaptionML=RUS=���⨭��;
                                                   Description=yuri 211114 }
    { 50057;  ;Night Time From     ;Time          ;CaptionML=RUS=�६� ���� �;
                                                   Description=yuri 101214 }
    { 50058;  ;Night Time To       ;Time          ;CaptionML=RUS=�६� ���� ��;
                                                   Description=yuri 101214 }
    { 50059;  ;Salary Unit of Meas.;Code10        ;TableRelation="Unit of Measure";
                                                   CaptionML=RUS=��௫�� ��. ����७��;
                                                   Description=yuri 171214 }
    { 50060;  ;Minutes For Hour    ;Integer       ;CaptionML=RUS=����� ��� ���㣫���� �� �� }
    { 50061;  ;Element Code        ;Code20        ;TableRelation="Payroll Element";
                                                   ValidateTableRelation=No;
                                                   CaptionML=[ENU=Element Code;
                                                              RUS=��� ����� ��௫���];
                                                   Description=yuri 211214 }
    { 50062;  ;Menu Happy Hours    ;Code20        ;TableRelation="���. ���� ���������";
                                                   ValidateTableRelation=No;
                                                   CaptionML=RUS=������ ���� Happy Hours;
                                                   Description=yuri 100415 }
    { 50063;  ;Mng. Class. Food    ;Code100       ;TableRelation="�����䨪��� ��㯯�".��� WHERE (�ਭ������� ���=CONST(Yes));
                                                   ValidateTableRelation=No;
                                                   CaptionML=RUS=�������� �����. ���;
                                                   Description=yuri 100415 }
    { 50064;  ;Mng. Class. Bev     ;Code100       ;TableRelation="�����䨪��� ��㯯�".��� WHERE (�ਭ������� ���=CONST(Yes));
                                                   ValidateTableRelation=No;
                                                   CaptionML=RUS=�������� �����. ��� ���.;
                                                   Description=yuri 100415 }
    { 50065;  ;Mng. Class. Alko Bev;Code100       ;TableRelation="�����䨪��� ��㯯�".��� WHERE (�ਭ������� ���=CONST(Yes));
                                                   ValidateTableRelation=No;
                                                   CaptionML=RUS=�������� �����. ���.;
                                                   Description=yuri 100415 }
    { 50066;  ;Dim4CB              ;Code20        ;TableRelation="Dimension Value".Code WHERE (Dimension Code=FIELD(Shortcut Dimension 4 Code));
                                                   CaptionML=RUS=���� C&&B;
                                                   Description=yuri 270515 }
    { 50067;  ;Dim4FBHB            ;Code20        ;TableRelation="Dimension Value".Code WHERE (Dimension Code=FIELD(Shortcut Dimension 4 Code));
                                                   CaptionML=RUS=���� FB-HB;
                                                   Description=yuri 130317 }
    { 67000;  ;Active Personal Log ;Boolean       ;CaptionML=RUS=������� ��� ����⢨� ���짮��⥫�;
                                                   Description=#67622 }
    { 69000;  ;Storno Resource No. ;Code20        ;TableRelation=Resource;
                                                   CaptionML=[ENU=Storno Resource No.;
                                                              RUS=����� ����� ��୮];
                                                   Description=79348 }
    { 69001;  ;Storno Restore Role ;Code20        ;TableRelation="User Role"."Role ID";
                                                   CaptionML=[ENU=Storno Restore Role;
                                                              RUS=���� ��୨஢���� � ���࠭�];
                                                   Description=79348 }
    { 69002;  ;Set Off Series No.  ;Code10        ;TableRelation="No. Series";
                                                   CaptionML=[ENU=Set Off Series No.;
                                                              RUS=����������� ���� ����஢] }
    { 21001510;;Dim3               ;Code20        ;TableRelation="Dimension Value".Code WHERE (Dimension Code=CONST(��� �������),
                                                                                               Dim 3=CONST(Yes)) }
    { 21001511;;Dim3Compl          ;Code20        ;TableRelation="Dimension Value".Code WHERE (Dimension Code=CONST(��� �������)) }
    { 21001512;;Dim3BN             ;Code20        ;TableRelation="Dimension Value".Code WHERE (Dimension Code=CONST(��� �������));
                                                   CaptionML=RUS=��� ��ꥪ� ��� ������ }
    { 21007419;;Dimension For Pay In FJ;Code20    ;TableRelation=Dimension.Code;
                                                   CaptionML=[ENU=Dimension For Pay In FJ;
                                                              RUS=��� ����७�� ��� ���. ���.] }
    { 21007420;;Dimension Value For Bonus;Code20  ;TableRelation="Dimension Value".Code WHERE (Dimension Code=FIELD(Dimension For Pay In FJ));
                                                   CaptionML=[ENU=Dimension Value For Bonus;
                                                              RUS=���祭�� ����७�� ��� ����ᮢ] }
    { 21007421;;Dimension Value For Money;Code20  ;TableRelation="Dimension Value".Code WHERE (Dimension Code=FIELD(Dimension For Pay In FJ));
                                                   CaptionML=[ENU=Dimension Value For Money;
                                                              RUS=���祭�� ����७�� ��� �����] }
    { 21007422;;Billiard External System;Integer  ;TableRelation="Restaurant External System";
                                                   CaptionML=RUS=������ ������ ���⥬� }
    { 21007423;;Bowling External System;Integer   ;TableRelation="Restaurant External System";
                                                   CaptionML=RUS=��㫨�� ������ ���⥬� }
    { 21007424;;Wi-Fi External System;Integer     ;TableRelation="Restaurant External System";
                                                   CaptionML=RUS=Wi-Fi ������ ���⥬� }
    { 21007426;;Edit Class.        ;Boolean       ;CaptionML=RUS=������஢��� �����䨪���;
                                                   Description=yuri 271014 }
    { 21007427;;Deposit Emp No.    ;Code20        ;TableRelation="_����㤭�� ����࠭�";
                                                   CaptionML=RUS=����㤭�� �����⨥ �������;
                                                   Description=yuri 230315 }
    { 21007428;;CB Emp No.         ;Code20        ;TableRelation="_����㤭�� ����࠭�";
                                                   CaptionML=RUS=����㤭�� �����⨥ ������;
                                                   Description=yuri 080615 }
    { 21007429;;Man.Class.Hookah   ;Code50        ;TableRelation="�����䨪��� ��㯯�".��� WHERE (�ਭ������� ���=CONST(Yes));
                                                   ValidateTableRelation=No;
                                                   CaptionML=RUS=���. �����. �����;
                                                   Description=yuri 290615 }
    { 21007430;;Show Emp No.       ;Code20        ;TableRelation="_����㤭�� ����࠭�";
                                                   CaptionML=RUS=����㤭�� �����⨥ ���;
                                                   Description=yuri 150119 }
  }
  KEYS
  {
    {    ;����                                    ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      ����㤭������࠭�@1000000000 : Record 21001403;
      RestFunc@1101967000 : Codeunit 21001403;

    BEGIN
    {
      yuri > 28.05.13 + Dim8 ���ᠫ. ��.
      csa 290914 (67622) - ����஢���� ����⢨� ���짮��⥫�
      apik 291014 (79348) ��������� ���� Storno Resource No.
    }
    END.
  }
}

