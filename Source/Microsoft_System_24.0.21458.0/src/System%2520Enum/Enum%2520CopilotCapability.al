// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.AI;

enum 2000000003 "Copilot Capability"
{
    Extensible = true;
    Caption = 'Copilot Capability';

    value(1; Chat)
    {
        Caption = 'Chat';
    }
    value(2; "Analyze List")
    {
        Caption = 'Analyze list';
    }
}