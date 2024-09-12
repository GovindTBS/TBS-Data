// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Reflection;

using System.Apps;

table 2000000231 "Report Layout Definition"
{
    Caption = 'Report Layout Definition';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = Cloud;

    fields
    {
        field(1; "Report ID"; Integer)
        {
            Caption = 'Report ID';
            TableRelation = Object.ID WHERE("Type" = const(Report));
        }

        field(2; "Name"; Text[250])
        {
            Caption = 'Name';
        }

        field(3; "Caption"; Text[250])
        {
            ObsoleteState = Pending;
            ObsoleteReason = 'This field should not be used. Instead, the layout caption should be obtained from the metareport';
            Caption = 'Caption';
        }

        field(4; "CaptionML"; Text[250])
        {
            ObsoleteState = Pending;
            ObsoleteReason = 'This field should not be used. Instead, the layout caption should be obtained from the metareport';
            Caption = 'CaptionML';
        }

        field(5; "Runtime Package ID"; Guid)
        {
            Caption = 'Runtime Package ID';
            TableRelation = "Installed Application"."Runtime Package ID";
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
            ObsoleteState = Pending;
            ObsoleteReason = 'This field should not be used. Custom reports only specify the mimetype.';
            Caption = 'Custom Type';
        }

        field(9; "MIME Type"; Text[255])
        {
            Caption = 'MIME Type';
        }

        field(10; Description; Text[250])
        {
            ObsoleteState = Pending;
            ObsoleteReason = 'This field should not be used. Instead, the layout description should be obtained from the metareport';
            Caption = 'Description';
        }
    }

    keys
    {
        key(key1; "Report ID", "Name", "Runtime Package ID")
        {
            Clustered = true;
        }
    }
}
