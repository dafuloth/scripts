#!/bin/bash

# Microwave Cooking Time Calculator
# Adjusts cooking times based on microwave wattage

echo "======================================"
echo "  Microwave Cooking Time Calculator"
echo "======================================"
echo

# Get original recipe power
echo "Enter the recipe's microwave power (watts):"
read -p "> " recipe_power

# Validate input
if ! [[ "$recipe_power" =~ ^[0-9]+$ ]] || [ "$recipe_power" -lt 100 ]; then
    echo "Error: Please enter a valid wattage (number >= 100)"
    exit 1
fi

# Get original cooking time
echo
echo "Enter the recipe's cooking time (mm:ss or just seconds):"
echo "Examples: 3:30 or 210"
read -p "> " recipe_time

# Parse time input
if [[ "$recipe_time" =~ ^([0-9]+):([0-9]+)$ ]]; then
    # Format is mm:ss
    minutes="${BASH_REMATCH[1]}"
    seconds="${BASH_REMATCH[2]}"
    total_seconds=$((minutes * 60 + seconds))
elif [[ "$recipe_time" =~ ^[0-9]+$ ]]; then
    # Format is just seconds
    total_seconds="$recipe_time"
else
    echo "Error: Invalid time format. Use mm:ss or seconds"
    exit 1
fi

if [ "$total_seconds" -le 0 ]; then
    echo "Error: Cooking time must be greater than 0"
    exit 1
fi

# Get your microwave's power
echo
echo "Enter YOUR microwave's power (watts):"
read -p "> " your_power

# Validate input
if ! [[ "$your_power" =~ ^[0-9]+$ ]] || [ "$your_power" -lt 100 ]; then
    echo "Error: Please enter a valid wattage (number >= 100)"
    exit 1
fi

# Calculate adjusted time
# Formula: new_time = original_time × (original_power / new_power)
adjusted_seconds=$(awk "BEGIN {print int($total_seconds * $recipe_power / $your_power)}")

# Convert back to mm:ss
adj_minutes=$((adjusted_seconds / 60))
adj_secs=$((adjusted_seconds % 60))

# Display results
echo
echo "======================================"
echo "         CALCULATION RESULTS"
echo "======================================"
printf "Recipe power:    %d watts\n" "$recipe_power"
printf "Recipe time:     %d:%02d\n" $((total_seconds / 60)) $((total_seconds % 60))
echo "--------------------------------------"
printf "Your power:      %d watts\n" "$your_power"
printf "Adjusted time:   %d:%02d\n" "$adj_minutes" "$adj_secs"
echo "======================================"

# Give helpful tip
if [ "$your_power" -lt "$recipe_power" ]; then
    echo
    echo "💡 Your microwave is less powerful - cook LONGER"
elif [ "$your_power" -gt "$recipe_power" ]; then
    echo
    echo "💡 Your microwave is more powerful - cook SHORTER"
else
    echo
    echo "💡 Same power - use the original time"
fi