// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Reflection;

table 2000000138 "Page Metadata"
{
    DataPerCompany = False;
    Scope = Cloud;
    //WriteProtected=True;
    InherentPermissions = rX;

    fields
    {
        field(1; ID; Integer)
        {
        }
        field(2; Name; Text[30])
        {
        }
        field(3; Caption; Text[80])
        {
        }
        field(4; Editable; Boolean)
        {
        }
        field(5; PageType; Option)
        {
            OptionMembers = Card,List,RoleCenter,CardPart,ListPart,Document,Worksheet,ListPlus,ConfirmationDialog,NavigatePage,StandardDialog,API,HeadlinePart;
        }
        field(6; CardPageID; Integer)
        {
        }
        field(7; "DataCaptionExpr."; Text[250])
        {
        }
        field(8; RefreshOnActivate; Boolean)
        {
        }
        field(9; APIPublisher; Text[40])
        {
        }
        field(10; APIGroup; Text[40])
        {
        }
        field(11; APIVersion; Text[250])
        {
        }
        field(12; EntitySetName; Text[250])
        {
        }
        field(13; EntityName; Text[250])
        {
        }
        field(14; SourceTable; Integer)
        {
        }
        field(15; SourceTableView; Text[250])
        {
        }
        field(16; InsertAllowed; Boolean)
        {
        }
        field(17; ModifyAllowed; Boolean)
        {
        }
        field(18; DeleteAllowed; Boolean)
        {
        }
        field(19; DelayedInsert; Boolean)
        {
        }
        field(20; ShowFilter; Boolean)
        {
        }
        field(21; MultipleNewLines; Boolean)
        {
        }
        field(22; SaveValues; Boolean)
        {
        }
        field(23; AutoSplitKey; Boolean)
        {
        }
        field(24; DataCaptionFields; Text[250])
        {
        }
        field(25; SourceTableTemporary; Boolean)
        {
        }
        field(26; LinksAllowed; Boolean)
        {
        }
        field(27; ChangeTrackingAllowed; Boolean)
        {
        }
        field(28; PopulateAllFields; Boolean)
        {
        }
    }

    keys
    {
        key(pk; ID)
        {

        }
    }
}