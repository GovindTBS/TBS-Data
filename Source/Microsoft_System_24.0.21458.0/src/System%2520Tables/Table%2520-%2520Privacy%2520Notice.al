// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Privacy;

using System.Security.AccessControl;

table 2000000237 "Privacy Notice"
{
    Caption = 'Privacy Notice';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = Cloud;

    fields
    {
        field(1; ID; Code[50])
        {
            Caption = 'Privacy Notice ID';
        }
        field(2; "Integration Service Name"; Text[250])
        {
            Caption = 'Integration Service Name';
        }
        field(3; Link; Text[2048])
        {
            Caption = 'Privacy Link';
        }
        field(4; "User SID Filter"; Guid)
        {
            Caption = 'User SID Filter';
            TableRelation = User."User Security ID";
            FieldClass = FlowFilter;
        }
        field(5; Enabled; Boolean)
        {
            // Note: In case both Enabled and Disabled are false, it means no decision has been made by the user in the User SID Filter.
            Caption = 'Enabled';
            FieldClass = FlowField;
            CalcFormula = exist("Privacy Notice Approval" where(ID = field(ID), "User SID" = field("User SID Filter"), Approved = const(true)));
        }
        field(6; Disabled; Boolean)
        {
            // Note: In case both Enabled and Disabled are false, it means no decision has been made by the user in the User SID Filter.
            Caption = 'Disabled';
            FieldClass = FlowField;
            CalcFormula = exist("Privacy Notice Approval" where(ID = field(ID), "User SID" = field("User SID Filter"), Approved = const(false)));
        }
    }

    keys
    {
        key(Key1; Id)
        {
            Clustered = true;
        }
        key(Key2; "Integration Service Name")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(Brick; "Integration Service Name")
        {
        }
    }
}
