// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Environment.Configuration;

table 2000000233 "Tenant Report Layout Selection"
{
    Caption = 'Tenant Report Layout Selection';
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

        field(2; "Layout Name"; Text[250])
        {
            Caption = 'Layout Name';
        }

        field(3; "App ID"; Guid)
        {
            Caption = 'App ID';
        }

        field(4; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
            TableRelation = System.Environment.Company.Name;
        }

        field(5; "User ID"; Guid)
        {
            Caption = 'User ID';
        }
    }

    keys
    {
        key(key1; "Report ID", "Company Name", "User ID")
        {
            Clustered = true;
        }
    }
}
