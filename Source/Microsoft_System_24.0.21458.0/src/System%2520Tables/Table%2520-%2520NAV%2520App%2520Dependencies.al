// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Apps;

/// <summary>
/// This table contains the dependency relationship between published applications.
/// </summary>
table 2000000161 "NAV App Dependencies"
{
    Caption = 'NAV App Dependencies';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;
    ObsoleteState = Removed;
    ObsoleteReason = 'This table is deprecated in favour of the "Application Dependency" table.';

    fields
    {
        field(1; "Package ID"; Guid)
        {
            Caption = 'Package ID';
        }
        field(2; ID; Guid)
        {
            Caption = 'ID';
        }
        field(3; Name; Text[250])
        {
            Caption = 'Name';
        }
        field(4; Publisher; Text[250])
        {
            Caption = 'Publisher';
        }
        field(5; "Version Major"; Integer)
        {
            Caption = 'Version Major';
        }
        field(6; "Version Minor"; Integer)
        {
            Caption = 'Version Minor';
        }
        field(7; "Version Build"; Integer)
        {
            Caption = 'Version Build';
        }
        field(8; "Version Revision"; Integer)
        {
            Caption = 'Version Revision';
        }
        field(9; "Compatibility Major"; Integer)
        {
            Caption = 'Compatibility Major';
        }
        field(10; "Compatibility Minor"; Integer)
        {
            Caption = 'Compatibility Minor';
        }
        field(11; "Compatibility Build"; Integer)
        {
            Caption = 'Compatibility Build';
        }
        field(12; "Compatibility Revision"; Integer)
        {
            Caption = 'Compatibility Revision';
        }
    }

    keys
    {
        key(Key1; "Package ID", ID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

