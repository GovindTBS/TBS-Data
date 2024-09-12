// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Environment.Configuration;

using System.Reflection;
using System.Security.AccessControl;

table 2000000075 "User Metadata"
{
    Caption = 'User Metadata';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = Cloud;
    ObsoleteState = Pending;
    ObsoleteReason = 'Support for V1 personalizations is being deprecated. User personalizations are now stored in the User Page Metadata table.';
    InherentPermissions = rX;

    fields
    {
        field(3; "User SID"; Guid)
        {
            Caption = 'User SID';
            TableRelation = User."User Security ID";
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(6; "User ID"; Code[50])
        {
            CalcFormula = Lookup(User."User Name" WHERE("User Security ID" = FIELD("User SID")));
            Caption = 'User ID';
            FieldClass = FlowField;
        }
        field(9; "Page ID"; Integer)
        {
            Caption = 'Page ID';
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(12; Description; Text[250])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object Type" = CONST(Page),
                                                                           "Object ID" = FIELD("Page ID")));
            Caption = 'Description';
            FieldClass = FlowField;
        }
        field(15; Date; Date)
        {
            Caption = 'Date';
        }
        field(18; Time; Time)
        {
            Caption = 'Time';
        }
        field(21; "Personalization ID"; Code[40])
        {
            Caption = 'Personalization ID';
        }
        field(24; "Page Metadata Delta"; BLOB)
        {
            Caption = 'Page Metadata Delta';
        }
    }

    keys
    {
        key(Key1; "User SID", "Page ID", "Personalization ID")
        {
            Clustered = true;
        }
        key(Key2; Date)
        {
        }
    }

    fieldgroups
    {
    }
}

