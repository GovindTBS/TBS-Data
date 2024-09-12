// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Environment;

table 2000000185 "Tenant Media Thumbnails"
{
    Caption = 'Tenant Media Thumbnails';
    DataPerCompany = false;
    Scope = Cloud;
    InherentPermissions = rX;

    fields
    {
        field(1; ID; Guid)
        {
            Caption = 'ID';
        }
        field(2; "Media ID"; Guid)
        {
            Caption = 'Media ID';
            TableRelation = "Tenant Media".ID WHERE(ID = FIELD("Media ID"));
        }
        field(3; Content; BLOB)
        {
            Caption = 'Content';
            SubType = Bitmap;
        }
        field(4; "Mime Type"; Text[100])
        {
            Caption = 'Mime Type';
        }
        field(5; Height; Integer)
        {
            Caption = 'Height';
        }
        field(6; Width; Integer)
        {
            Caption = 'Width';
        }
        field(7; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
            TableRelation = System.Environment.Company.Name;
        }
        field(8; Embedded; Boolean)
        {
            Caption = 'Embedded';
        }
    }

    keys
    {
        key(Key1; ID)
        {
            Clustered = true;
        }
        key(Key2; "Media ID")
        {
        }
    }

    fieldgroups
    {
    }
}

