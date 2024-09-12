// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Environment;

using System.Reflection;

table 2000000175 "Scheduled Task"
{
    Caption = 'Scheduled Task';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = Cloud;

    fields
    {
        field(1; ID; Guid)
        {
            Caption = 'ID';
        }
        field(2; "User ID"; Guid)
        {
            Caption = 'User ID';
        }
        field(3; "User Name"; Text[50])
        {
            Caption = 'User Name';
        }
        field(4; "User Language ID"; Integer)
        {
            Caption = 'User Language ID';
        }
        field(5; "User Format ID"; Integer)
        {
            Caption = 'User Format ID';
        }
        field(6; "User Time Zone"; Text[32])
        {
            Caption = 'User Time Zone';
        }
        field(7; "User App ID"; Text[20])
        {
            Caption = 'User App ID';
        }
        field(10; Company; Text[30])
        {
            Caption = 'Company';
            TableRelation = System.Environment.Company.Name;
        }
        field(11; "Is Ready"; Boolean)
        {
            Caption = 'Is Ready';
        }
        field(12; "Not Before"; DateTime)
        {
            Caption = 'Not Before';
        }
        field(20; "Run Codeunit"; Integer)
        {
            Caption = 'Run Codeunit';
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Codeunit));
        }
        field(21; "Failure Codeunit"; Integer)
        {
            Caption = 'Failure Codeunit';
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Codeunit));
        }
        field(22; "Record"; RecordID)
        {
            Caption = 'Record';
        }
        field(23; "Timeout"; Duration)
        {
            Caption = 'Timeout';
        }
        field(24; "Tenant ID"; Text[128])
        {
            Caption = 'Tenant ID';
        }
        field(25; "Last Error"; BLOB)
        {
            Caption = 'Last Error';
        }
    }

    keys
    {
        key(Key1; ID)
        {
            Clustered = true;
        }
        key(Key2; "Record")
        {
        }
        key(Key3; "Tenant ID", "Not Before")
        {
        }
    }

    fieldgroups
    {
    }
}

