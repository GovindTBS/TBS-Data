// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Environment;

table 2000000182 "Media Resources"
{
    Caption = 'Media Resources';
    DataPerCompany = false;
    Scope = Cloud;
    InherentPermissions = rX;

    fields
    {
        field(1; "Code"; Code[50])
        {
            Caption = 'Code';
        }
        field(2; "MediaSet Reference"; MediaSet)
        {
            Caption = 'MediaSet Reference';
        }
        field(3; "Media Reference"; Media)
        {
            Caption = 'Media Reference';
        }
        field(4; Blob; BLOB)
        {
            Caption = 'Blob';
            SubType = UserDefined;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

