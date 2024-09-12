// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Reflection;

using System.Apps;

table 2000000234 "Report Layout List"
{
    Caption = 'Report Layout List';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = Cloud;

    fields
    {
        field(1; "Report ID"; Integer)
        {
            Caption = 'Report ID';
            TableRelation = "Report Metadata".ID;
        }

        field(2; "Name"; Text[250])
        {
            Caption = 'Name';
        }

        field(3; "Caption"; Text[250])
        {
            Caption = 'Caption';
        }

        field(4; "CaptionML"; Text[250])
        {
            Caption = 'CaptionML';
        }

        field(5; "Runtime Package ID"; Guid)
        {
            Caption = 'Runtime Package ID';
            TableRelation = "Report Layout Definition"."Runtime Package ID";
        }

        field(6; "Layout"; Media)
        {
            Caption = 'Layout';
        }

        field(7; "Layout Format"; Option)
        {
            Caption = 'Layout Format';
            OptionCaption = 'RDLC,Word,Excel,External';
            OptionMembers = RDLC,Word,Excel,Custom;
        }

        field(8; "Custom Type"; Guid)
        {
            Caption = 'Custom Type';
        }

        field(9; "MIME Type"; Text[255])
        {
            Caption = 'MIME Type';
        }

        field(10; Description; Text[250])
        {
            Caption = 'Description';
        }

        field(11; "Application ID"; Guid)
        {
            Caption = 'Application ID';
            TableRelation = "Installed Application"."Package ID";
        }

        field(12; "Report Name"; Text[250])
        {
            Caption = 'Report Name';
        }

        field(13; "Layout Publisher"; Text[250])
        {
            Caption = 'Layout Provider';
        }

        field(14; "User Defined"; Boolean)
        {
            Caption = 'User Defined';
        }

        field(15; ReportIsInstalled; Boolean)
        {
            Caption = 'Report Is Installed';
        }
    }

    keys
    {
        key(key1; "Report ID", "Name", "Runtime Package ID")
        {
            Clustered = true;
        }

        key(key2; "Report ID", "Name", "Application ID")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(Brick; "Report ID", Name, Caption, Description, "Layout Format")
        {
        }
    }
}
