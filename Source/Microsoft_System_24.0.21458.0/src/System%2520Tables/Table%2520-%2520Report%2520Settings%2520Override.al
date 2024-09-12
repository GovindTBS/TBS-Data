// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Environment.Configuration;

using System.Environment;
using System.Globalization;
using System.Reflection;

table 2000000228 "Report Settings Override"
{
    Caption = 'Report Settings Override';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;

    fields
    {
        field(1; "Object ID"; Integer)
        {
            Caption = 'Object ID';
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Report));
        }

        field(2; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
            TableRelation = Company.Name;
        }

        field(3; "Timeout"; Integer)
        {
            Caption = 'Timeout';
        }

        field(4; "MaxRows"; Integer)
        {
            Caption = 'Maximum rows';
        }

        field(5; "MaxDocuments"; Integer)
        {
            Caption = 'Maximum documents';
        }
        field(6; "Format Language Tag"; Text[80]) // Length to match VT Windows Language field size
        {
            Caption = 'Format Language Tag';
            TableRelation = "Windows Language"."Language Tag";
        }
        field(7; "Language ID"; Integer)
        {
            Caption = 'Application Language';
            TableRelation = "Windows Language"."Language ID";
        }
    }

    keys
    {
        key(Key1; "Object ID", "Company Name")
        {
            Clustered = true;
        }
    }
}