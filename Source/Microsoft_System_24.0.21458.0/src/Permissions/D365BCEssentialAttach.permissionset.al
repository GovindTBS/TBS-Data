// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

namespace System.Security.AccessControl;

using System.Apps;
using System.Environment;
using System.Environment.Configuration;
using System.Integration;
using System.Reflection;
using System.Tooling;

permissionset 2000000024 D365BCEssentialAttach
{
    Assignable = false;
    IncludedPermissionSets = BaseSystemPermissionSet,
                             "Role Configuration - Read";
    Permissions = tabledata "All Profile" = RIMD,
                  tabledata "API Webhook Notification" = RIMD,
                  tabledata "API Webhook Notification Aggr" = RIMD,
                  tabledata "API Webhook Subscription" = RIMD,
                  tabledata "Application Dependency" = Rimd,
                  tabledata "Application Object Metadata" = Rimd,
                  tabledata "Application Resource" = Rimd,
                  tabledata Company = RIMD,
                  tabledata "Configuration Package File" = RIMD,
                  tabledata "Designed Query Group" = RIMD,
                  tabledata "Designed Query Permission" = RIMD,
                  tabledata "External Event Subscription" = RIMD,
                  tabledata "External Event Log Entry" = RIMD,
                  tabledata "External Event Notification" = RIMD,
                  tabledata "Feature Key" = RIMD,
                  tabledata "Installed Application" = Rimd,
                  tabledata "Inplace Installed Application" = Rimd,
                  tabledata "NAV App Capabilities" = Rimd,
                  tabledata "NAV App Data Archive" = Rimd,
                  tabledata "NAV App Installed App" = Rimd,
                  tabledata "NAV App Object Prerequisites" = Rimd,
                  tabledata "NAV App Tenant Add-In" = Rimd,
                  tabledata "NAV App Tenant Operation" = RIMD,
                  tabledata "Published Application" = Rimd,
                  tabledata "User Default Style Sheet" = RIMD,
                  tabledata "User Page Metadata" = RIMD,
                  tabledata "Webhook Notification" = RIMD;
}
