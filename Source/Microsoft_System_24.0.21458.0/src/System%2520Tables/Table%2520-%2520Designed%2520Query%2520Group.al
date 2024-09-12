// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Tooling;

table 2000000224 "Designed Query Group"
{
    Caption = 'Designed Query Group';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;

    fields
    {
        field(1; "Query ID"; BigInteger)
        {
            Caption = 'Query ID';
        }

        field(2; "Group"; Text[100])
        {
            Caption = 'Group';
        }
    }

    keys
    {
        key(PK; "Query Id", "Group")
        {
            Clustered = true;
        }
    }
}