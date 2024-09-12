// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Environment.Configuration;

using System.Reflection;
using System.Security.AccessControl;

table 2000000188 "User Page Metadata"
{
    Caption = 'User Page Metadata';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;
    InherentPermissions = rX;

    fields
    {
        field(1; "User SID"; Guid)
        {
            Caption = 'User SID';
            TableRelation = User."User Security ID";
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(2; "Page ID"; Integer)
        {
            Caption = 'Page ID';
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(3; "Page Metadata"; BLOB)
        {
            Caption = 'Page Metadata';
        }
        field(4; "Page AL"; BLOB)
        {
            Caption = 'Page AL';
        }
        field(5; "Emit Version"; Integer)
        {
            Caption = 'Emit Version';
        }
    }

    keys
    {
        key(Key1; "User SID", "Page ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

