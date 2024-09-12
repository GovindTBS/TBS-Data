// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Security.AccessControl;

table 2000000055 "SID - Account ID"
{
    DataPerCompany = false;
    Scope = OnPrem;
    //WriteProtecte=True;
    fields
    {
        field(1; SID; text[118])
        {
        }
        field(2; ID; text[130])
        {
        }
    }

    keys
    {
        key(pk; SID)
        {

        }
        key(fk; ID)
        {

        }
    }
}