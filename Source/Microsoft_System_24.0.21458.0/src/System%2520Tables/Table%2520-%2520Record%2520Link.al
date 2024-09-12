// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Environment.Configuration;

table 2000000068 "Record Link"
{
    Caption = 'Record Link';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = Cloud;
    InherentPermissions = rX;

    fields
    {
        field(1; "Link ID"; Integer)
        {
            AutoIncrement = true;
            Caption = 'Link ID';
        }
        field(2; "Record ID"; RecordID)
        {
            Caption = 'Record ID';
        }
        field(3; URL1; Text[2048])
        {
            Caption = 'URL1';
        }
        field(4; URL2; Text[250])
        {
            Caption = 'URL2';
            ObsoleteReason = 'URL1 field size increased';
            ObsoleteState = Removed;
        }
        field(5; URL3; Text[250])
        {
            Caption = 'URL3';
            ObsoleteReason = 'URL1 field size increased';
            ObsoleteState = Removed;
        }
        field(6; URL4; Text[250])
        {
            Caption = 'URL4';
            ObsoleteReason = 'URL1 field size increased';
            ObsoleteState = Removed;
        }
        field(7; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(8; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Link,Note';
            OptionMembers = Link,Note;
        }
        field(9; Note; BLOB)
        {
            Caption = 'Note';
            SubType = Memo;
        }
        field(10; Created; DateTime)
        {
            Caption = 'Created';
        }
        field(11; "User ID"; Text[132])
        {
            Caption = 'User ID';
        }
        field(12; Company; Text[30])
        {
            Caption = 'Company';
            TableRelation = System.Environment.Company.Name;
        }
        field(13; Notify; Boolean)
        {
            Caption = 'Notify';
        }
        field(14; "To User ID"; Text[132])
        {
            Caption = 'To User ID';
        }
    }

    keys
    {
        key(Key1; "Link ID")
        {
            Clustered = true;
        }
        key(Key2; "Record ID")
        {
        }
        key(Key3; Company, "Record ID")
        {
        }
    }

    fieldgroups
    {
    }
}

