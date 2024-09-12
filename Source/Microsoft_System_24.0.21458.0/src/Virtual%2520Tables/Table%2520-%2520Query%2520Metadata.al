// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Reflection;

table 2000000142 "Query Metadata"
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
        field(4; APIPublisher; Text[40])
        {
        }
        field(5; APIGroup; Text[40])
        {
        }
        field(6; APIVersion; Text[250])
        {
        }
        field(7; EntitySetName; Text[250])
        {
        }
        field(8; EntityName; Text[250])
        {
        }
        field(9; Category; Text[250])
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