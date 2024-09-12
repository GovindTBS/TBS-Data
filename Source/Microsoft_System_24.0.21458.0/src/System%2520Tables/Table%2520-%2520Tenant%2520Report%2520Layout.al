// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Environment.Configuration;

table 2000000232 "Tenant Report Layout"
{
    Caption = 'Tenant Report Layout';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = Cloud;

    fields
    {
        field(1; "Report ID"; Integer)
        {
            Caption = 'Report ID';
            TableRelation = System.Reflection.Object.ID WHERE("Type" = const(Report));
        }

        field(2; "Name"; Text[250])
        {
            Caption = 'Name';
        }

        field(3; "Caption"; Text[250])
        {
            ObsoleteState = Pending;
            ObsoleteReason = 'This field should not be used. Use the Name field instead.';
            Caption = 'Caption';
        }

        field(4; "CaptionML"; Text[250])
        {
            ObsoleteState = Pending;
            ObsoleteReason = 'This field should not be used. Use the Name field instead.';
            Caption = 'CaptionML';
        }

        field(5; "App ID"; Guid)
        {
            Caption = 'App ID';
        }

        field(6; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
            TableRelation = System.Environment.Company.Name;
        }

        field(7; "Layout"; Media)
        {
            Caption = 'Layout';
        }

        field(8; "Layout Format"; Option)
        {
            Caption = 'Layout Format';
            OptionCaption = 'RDLC,Word,Excel,External';
            OptionMembers = RDLC,Word,Excel,Custom;
        }

        field(9; "Custom Type"; Guid)
        {
            Caption = 'Custom Type';
        }

        field(10; "MIME Type"; Text[255])
        {
            Caption = 'MIME Type';
        }

        field(11; Description; Text[250])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(key1; "Report ID", "Name", "App ID")
        {
            Clustered = true;
        }
    }
}
