// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Reflection;

table 2000000202 "All Control Fields"
{
    Caption = 'All Control Fields';
    Scope = Cloud;

    fields
    {
        field(1; "Object Type"; Option)
        {
            Caption = 'Object Type';
            OptionMembers = ,,,"Report",,,"XMLport",,"Page",,,,,,,,,,,;
            OptionCaption = ',,,Report,,,XMLport,,Page,,,,,,,,,,,';
        }
        field(2; "Object ID"; Integer)
        {
            Caption = 'Object ID';
        }
        field(3; "Control ID"; Integer)
        {
            Caption = 'Control ID';
        }
        field(4; "Control Name"; Text[120])
        {
            Caption = 'Control Name';
        }
        field(5; "Data Type"; Option)
        {
            Caption = 'Data Type';
            OptionMembers = BigInteger,Binary,Blob,Boolean,Code,Date,DateFormula,DateTime,Decimal,Duration,GUID,Integer,Media,MediaSet,OEMCode,OemText,Option,RecordID,TableFilter,Text,Time;
            OptionOrdinalValues = 36095, 33791, 33793, 34047, 31489, 11775, 11797, 37375, 12799, 36863, 37119, 34559, 26207, 26208, 35071, 11519, 35583, 4988, 4912, 31488, 11776;
        }
        field(6; "Data Type Length"; Integer)
        {
            Caption = 'Data Type Length';
        }
        field(7; "Option String"; Text[2048])
        {
            Caption = 'Option String';
        }
        field(8; "Option Caption"; Text[2048])
        {
            Caption = 'Option Caption';
        }
        field(9; "Caption"; Text[250])
        {
            Caption = 'Caption';
        }
        field(10; "Related Table ID"; Integer)
        {
            Caption = 'Related Table ID';
        }
        field(11; "Related Field ID"; Integer)
        {
            Caption = 'Related Field ID';
        }
        field(12; "Source Expression"; Text[512])
        {
            Caption = 'Source Expression';
        }
    }
    keys
    {
        key(PK; "Object Type", "Object ID", "Control ID")
        {
        }
    }
}