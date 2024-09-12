// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Environment.Configuration;

using System.Globalization;
using System.Reflection;
using System.Security.AccessControl;

table 2000000073 "User Personalization"
{
    Caption = 'User Personalization';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = Cloud;

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
        field(7; "Full Name"; Text[80])
        {
            Caption = 'Full Name';
            CalcFormula = Lookup(User."Full Name" WHERE("User Name" = FIELD("User ID")));
            FieldClass = FlowField;
        }
        field(9; "Profile ID"; Code[30])
        {
            Caption = 'Profile ID';
            TableRelation = "All Profile"."Profile ID";
        }
        field(10; "App ID"; Guid)
        {
            Caption = 'App ID';
        }
        field(11; Scope; Option)
        {
            Caption = 'Scope';
            OptionCaption = 'System,Tenant';
            OptionMembers = System,Tenant;
        }
        field(12; "Language ID"; Integer)
        {
            Caption = 'Language ID';
        }
        field(13; "Language Name"; Text[80])
        {
            Caption = 'Language';
            CalcFormula = Lookup("Windows Language".Name WHERE("Language ID" = FIELD("Language ID")));
            FieldClass = FlowField;
        }
        field(15; Company; Text[30])
        {
            Caption = 'Company';
            TableRelation = System.Environment.Company.Name;
        }
        field(18; "Debugger Break On Error"; Boolean)
        {
            Caption = 'Debugger Break On Error';
            InitValue = true;
            ObsoleteState = Removed;
            ObsoleteReason = 'Support for the classic debugger engine has been removed.';
        }
        field(21; "Debugger Break On Rec Changes"; Boolean)
        {
            Caption = 'Debugger Break On Rec Changes';
            ObsoleteState = Removed;
            ObsoleteReason = 'Support for the classic debugger engine has been removed.';
        }
        field(24; "Debugger Skip System Triggers"; Boolean)
        {
            Caption = 'Debugger Skip System Triggers';
            InitValue = true;
            ObsoleteState = Removed;
            ObsoleteReason = 'Support for the classic debugger engine has been removed.';
        }
        field(27; "Locale ID"; Integer)
        {
            Caption = 'Locale ID';
        }
        field(28; Region; Text[80])
        {
            Caption = 'Region';
            CalcFormula = Lookup("Windows Language".Name WHERE("Language ID" = FIELD("Locale ID")));
            FieldClass = FlowField;
        }
        field(30; "Time Zone"; Text[180])
        {
            Caption = 'Time Zone';
        }
        field(31; "License Type"; Option)
        {
            CalcFormula = Lookup(User."License Type" WHERE("User Security ID" = FIELD("User SID")));
            Caption = 'License Type';
            FieldClass = FlowField;
            OptionCaption = 'Full User,Limited User,Device Only User,Windows Group,External User,External Administrator,External Accountant,Application,AAD Group';
            OptionMembers = "Full User","Limited User","Device Only User","Windows Group","External User","External Administrator","External Accountant","Application","AAD Group";
        }
        field(32; "Customization Status"; Option)
        {
            Access = Internal;
            Caption = 'Customization Status';
            OptionCaption = 'Updated,Recompilation Needed,Recompilation Failed';
            OptionMembers = Updated,"Recompilation Needed","Recompilation Failed";
        }
        field(33; Role; Text[100])
        {
            Caption = 'Role';
            CalcFormula = Lookup("All Profile".Caption WHERE("Profile ID" = FIELD("Profile ID"), Scope = FIELD(Scope), "App ID" = FIELD("App ID")));
            FieldClass = FlowField;
        }
        field(34; "Emit Version"; Integer)
        {
            Caption = 'Emit Version';
        }
    }

    keys
    {
        key(Key1; "User SID")
        {
            Clustered = true;
        }
        key(Key2; "Profile ID")
        {
        }
        key(Key3; Company)
        {
        }
    }

    fieldgroups
    {
    }
}

