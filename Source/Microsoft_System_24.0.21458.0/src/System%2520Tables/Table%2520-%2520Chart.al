// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Reflection;

table 2000000078 Chart
{
    Caption = 'Chart';
    DataPerCompany = false;
    Scope = Cloud;
    ObsoleteState = Pending;
    ObsoleteReason = 'Legacy charts used for Windows Client only. Will be removed in the next major release.';

    fields
    {
        field(3; ID; Code[20])
        {
            Caption = 'ID';
        }
        field(6; Name; Text[30])
        {
            Caption = 'Name';
        }
        field(9; BLOB; BLOB)
        {
            Caption = 'BLOB';
        }
    }

    keys
    {
        key(Key1; ID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

