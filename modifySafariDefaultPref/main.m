//
//  main.m
//  modifySafariDefaultPref
//
//  Created by shenyixin on 13-12-12.
//  Copyright (c) 2013年 http://www.helloitworks.com. All rights reserved.
//



int main(int argc, const char * argv[])
{
    
    CFStringRef bundleId = CFSTR("com.apple.Safari");
    CFStringRef key = CFSTR("managedPlugInPolicies");
    NSMutableDictionary *managedPlugInPolicies = [NSMutableDictionary dictionaryWithDictionary:(__bridge NSDictionary *)CFPreferencesCopyAppValue(key,bundleId)];
    if (managedPlugInPolicies.count == 0) {
        return 0;
    }
    NSMutableDictionary *thunderPlugin = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)[managedPlugInPolicies objectForKey:@"com.xunlei.thunderplugin"]];
    if (thunderPlugin.count == 0) {
        return 0;
    }
    
    //把ManagedPlugInPolicies/com.xunlei.thunderplugin/PlugInFirstVisitPolicy的规则修改为允许
    [thunderPlugin setObject:@"PlugInPolicyAllowWithSecurityRestrictions" forKey:@"PlugInFirstVisitPolicy"];
    
    //把ManagedPlugInPolicies/com.xunlei.thunderplugin/PlugInHostnamePolicies里面每一项的规则修改为允许；
    NSMutableArray *thunderPluginHostnamePolicies = [NSMutableArray arrayWithArray:(NSArray *)[thunderPlugin objectForKey:@"PlugInHostnamePolicies"]];
    if (thunderPluginHostnamePolicies.count > 0) {
        for (NSUInteger i = 0; i < thunderPluginHostnamePolicies.count; i++)
        {
            NSMutableDictionary *hostnamePolicy = [thunderPluginHostnamePolicies  objectAtIndex:i];
            [hostnamePolicy setObject:@"PlugInPolicyAllowWithSecurityRestrictions" forKey:@"PlugInPolicy"];
            [thunderPluginHostnamePolicies replaceObjectAtIndex:i withObject:hostnamePolicy];
        }
        [thunderPlugin setObject:thunderPluginHostnamePolicies forKey:@"PlugInHostnamePolicies"];
    }
   
    //设置新的值
    [managedPlugInPolicies setObject:thunderPlugin forKey:@"com.xunlei.thunderplugin"];
    //修改后同步
    CFPreferencesSetAppValue(CFSTR("managedPlugInPolicies"),
                             (__bridge CFPropertyListRef)managedPlugInPolicies,
                             bundleId);
    
    NSLog(@"ddd");
    CFPreferencesAppSynchronize(bundleId);
    
    return 0;
}
