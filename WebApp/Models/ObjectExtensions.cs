using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.ComponentModel.DataAnnotations;
using System.Data.Entity;
using System.Data.Entity.Core.Metadata.Edm;
using System.Data.Entity.Infrastructure;

namespace WebApp.Models.Extensions
{
    public static class ObjectExtensions
    {
        /// <summary>
        /// Copies all properties from source object to target object, automatically excluding key fields
        /// </summary>
        /// <typeparam name="T">Type of the objects</typeparam>
        /// <param name="target">Target object to copy properties to</param>
        /// <param name="source">Source object to copy properties from</param>
        /// <param name="dbContext">Optional DbContext to detect primary keys from database metadata</param>
        public static void CopyPropertiesFrom<T>(this T target, T source, DbContext dbContext = null)
        {
            if (source == null || target == null)
                return;

            Type type = typeof(T);
            PropertyInfo[] properties = type.GetProperties(BindingFlags.Public | BindingFlags.Instance);

            // Get key properties from attributes and database metadata
            var keyProperties = GetKeyProperties(type, dbContext);

            foreach (PropertyInfo property in properties)
            {
                // Skip if property is a key property
                if (keyProperties.Contains(property.Name))
                    continue;

                // Skip if property is read-only
                if (!property.CanWrite)
                    continue;

                // Skip if property is an indexer
                if (property.GetIndexParameters().Length > 0)
                    continue;

                try
                {
                    object value = property.GetValue(source);
                    property.SetValue(target, value);
                }
                catch
                {
                    // Skip properties that can't be read or written
                    continue;
                }
            }
        }

        private static HashSet<string> GetKeyProperties(Type type, DbContext dbContext)
        {
            var keyProperties = new HashSet<string>();

            // 1. Check for [Key] attributes
            foreach (var property in type.GetProperties())
            {
                if (property.GetCustomAttribute<KeyAttribute>() != null)
                {
                    keyProperties.Add(property.Name);
                }
            }

            // 2. If DbContext is provided, check database metadata
            if (dbContext != null)
            {
                try
                {
                    var objectContext = ((IObjectContextAdapter)dbContext).ObjectContext;
                    var metadata = objectContext.MetadataWorkspace;
                    var entityType = metadata.GetItems<EntityType>(DataSpace.CSpace)
                        .FirstOrDefault(e => e.Name == type.Name);

                    if (entityType != null)
                    {
                        foreach (var keyMember in entityType.KeyMembers)
                        {
                            keyProperties.Add(keyMember.Name);
                        }
                    }
                }
                catch
                {
                    // If we can't get metadata, just use the attributes we found
                }
            }

            // 3. Add common key property names as fallback
            if (keyProperties.Count == 0)
            {
                var commonKeyNames = new[] { "Id", "No_", "Code" };
                foreach (var name in commonKeyNames)
                {
                    if (type.GetProperty(name) != null)
                    {
                        keyProperties.Add(name);
                    }
                }
            }

            return keyProperties;
        }

        /// <summary>
        /// Checks if string length is less than 500 characters and splits it by the last "-" character
        /// Only splits if string length is greater than 250 characters
        /// </summary>
        /// <param name="input">The input string to process</param>
        /// <returns>A tuple containing the split parts and a boolean indicating if length is less than 500</returns>
        public static (string part1, string part2, bool isValidLength) SplitByLastDash(this string input)
        {
            if (string.IsNullOrEmpty(input))
                return (string.Empty, string.Empty, false);

            bool isValidLength = input.Length < 500;

            // If string length is less than or equal to 250, return without splitting
            if (input.Length <= 250)
                return (input, string.Empty, isValidLength);

            // Find the last dash position within first 250 characters
            int lastDashIndex = input.Substring(0, 250).LastIndexOf('-');

            if (lastDashIndex == -1)
                return (input, string.Empty, isValidLength);

            string part1 = input.Substring(0, lastDashIndex);
            string part2 = input.Substring(lastDashIndex + 1);

            return (part1, part2, isValidLength);
        }

        /// <summary>
        /// Removes the first and last character from a string only if they are double quotes (")
        /// </summary>
        /// <param name="input">The input string to process</param>
        /// <returns>The string with first and last quotes removed if they exist, otherwise returns original string</returns>
        public static string RemoveQuotes(this string input)
        {
            if (string.IsNullOrEmpty(input) || input.Length < 2)
                return input;

            if (input[0] == '"' && input[input.Length - 1] == '"')
                return input.Substring(1, input.Length - 2);

            return input;
        }
    }
}