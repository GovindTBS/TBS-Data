// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Apps;

/// <summary>
/// This table contains the resources of a published application.
/// </summary>
table 2000000176 "NAV App Resource"
{
    Caption = 'NAV App Resource';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;
    ObsoleteState = Removed;
    ObsoleteReason = 'This table is deprecated in favour of the "Application Resource" table.';

    fields
    {
        field(1; "Package ID"; Guid)
        {
            Caption = 'Package ID';
        }
        field(2; Type; Integer)
        {
            Caption = 'Type';
        }
        field(3; Name; Text[250])
        {
            Caption = 'Name';
        }
        field(4; Content; BLOB)
        {
            Caption = 'Content';
        }
        field(5; Hash; Text[64])
        {
            Caption = 'Hash';
        }
    }

    keys
    {
        key(Key1; "Package ID", Type, Name)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

