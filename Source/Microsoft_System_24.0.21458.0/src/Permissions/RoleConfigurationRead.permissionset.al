// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

namespace System.Security.AccessControl;

using System.Environment.Configuration;
using System.Reflection;

permissionset 2000000026 "Role Configuration - Read"
{
    Caption = 'Role Configuration - Read only';
    Assignable = false;
    // Permission to edit role configuration is tied to direct modify on "All Profile" table.
    Permissions = tabledata Profile = RIMD,
                  tabledata "Profile Configuration Symbols" = RIMD,
                  tabledata "Tenant Profile" = RIMD,
                  tabledata "Tenant Profile Extension" = RIMD,
                  tabledata "Tenant Profile Page Metadata" = RIMD,
                  tabledata "Tenant Profile Setting" = RIMD;
}