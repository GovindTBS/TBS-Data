// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Reflection;

table 2000000143 "Page Action"
{
    Caption = 'Page Action';
    DataPerCompany = false;
    Scope = Cloud;
    InherentPermissions = rX;

    fields
    {
        field(1; "Page ID"; Integer)
        {
            Caption = 'Page ID';
        }
        field(2; "Action Index"; Integer)
        {
            Caption = 'Action Index';
        }
        field(3; "Action ID"; Integer)
        {
            Caption = 'Action ID';
        }
        field(4; Indentation; Integer)
        {
            Caption = 'Indentation';
        }
        field(5; "Parent Action ID"; Integer)
        {
            Caption = 'Parent Action ID';
        }
        field(6; "Action Type"; Option)
        {
            Caption = 'Action Type';
            OptionMembers = ActionContainer,Action,Separator,ActionGroup,CustomAction,FileUploadAction;
        }
        field(7; "Action Subtype"; Option)
        {
            Caption = 'Action Subtype';
            OptionMembers = ,NewDocumentItems,ActionItems,RelatedInformation,Reports,HomeItems,ActivityButtons,Departments,,,,,SystemActions,Prompting,PromptGuide;
        }
        field(8; Name; Text[30])
        {
            Caption = 'Name';
        }
        field(9; Caption; Text[80])
        {
            Caption = 'Caption';
        }
        field(10; ToolTip1; Text[250])
        {
            Caption = 'ToolTip1';
        }
        field(11; ToolTip2; Text[250])
        {
            Caption = 'ToolTip2';
        }
        field(12; ToolTip3; Text[250])
        {
            Caption = 'ToolTip3';
        }
        field(13; ToolTip4; Text[250])
        {
            Caption = 'ToolTip4';
        }
        field(14; Promoted; Boolean)
        {
            Caption = 'Promoted';
        }
        field(15; RunObjectType; Option)
        {
            Caption = 'RunObjectType';
            OptionMembers = ,Page,Report,Codeunit,XMLport;
        }
        field(16; RunObjectID; Integer)
        {
            Caption = 'RunObjectID';
        }
        field(17; RunPageMode; Option)
        {
            Caption = 'RunPageMode';
            OptionMembers = ,View,Edit,Create;
        }
        field(18; RunSourceTable; Integer)
        {
            Caption = 'RunSourceTable';
        }
        field(19; ApplicationArea; Text[250])
        {
            Caption = 'ApplicationArea';
        }
    }
    keys
    {
        key(Key1; "Page ID", "Action Index")
        {
        }
    }
}