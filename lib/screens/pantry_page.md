# PantryPage (lib/screens/pantry_page.dart)

## Overview

`PantryPage` is a StatefulWidget that displays and manages the user's pantry items. It uses a `PantryProvider` (via `provider` package) as its source of truth. Items are shown in a scrollable list, and the user can add items, scan barcodes, or edit item details. A floating Speed Dial provides quick actions (scan and add).

This screen coordinates multiple dialogs and flows: creating a pantry (if none exists), adding/editing items, scanning a barcode, and changing item quantities.

## Responsibilities / Purpose

- Load pantry data at screen initialization.
- Prompt the user to create a pantry if none exists yet.
- Render a list of `PantryItemModel` entries using `PantryItemTile`.
- Allow quantity adjustments directly from the tile (increment, decrement, direct change).
- Expose actions to scan an item barcode and add or edit items through dialogs.
- Display transient feedback to the user (SnackBars) for scan results or validation.

## Key dependencies

- Flutter
- provider (for `PantryProvider` state management)
- flutter_speed_dial (for the floating action Speed Dial)
- Local widgets and models:
  - `PantryItemModel` (model for pantry item)
  - `PantryProvider` (provider for loading/updating items)
  - `AddItemDialog` (UI for creating a new item)
  - `EditItemDialog` (UI for editing an existing item)
  - `NewPantryPrompt` (dialog shown to create a pantry name)
  - `PantryItemTile` (tile that renders a single pantry row)
  - `ScanPage` (scanner screen that returns a barcode string)

## Lifecycle and behavior

- initState:
  - Adds a post-frame callback that asks the `PantryProvider` to `loadPantryItems()`.
  - If loading fails or provider indicates no pantry exists, the user is prompted (via `NewPantryPrompt`) to create a pantry name; this dialog is non-dismissible and will re-appear until a non-empty name is provided.
  - After getting a pantry name, the provider's `createPantry(pantryName)` is called, and pantry items are re-loaded.

- build:
  - Uses `Consumer<PantryProvider>` to reactively render UI according to provider state.
  - While `pantry.loading` is true a `CircularProgressIndicator` is shown.
  - If `pantry.items` is empty (not just loading), a centered `Text('Empty Pantry')` is shown.
  - Otherwise, a `ListView.builder` renders `PantryItemTile` for each item.
  - `SpeedDial` is used for floating actions: "Scan Item" and "Add Item".

## Important methods

- Future<void> _onScanButtonPressed(BuildContext context)
  - Navigates to `ScanPage` with `Navigator.push()` and awaits the result.
  - On non-null result, shows a SnackBar with the scanned barcode and prints debug output.
  - TODO (in code): integrate barcode result with pantry (e.g., lookup or create item by barcode).

- Future<void> _onAddItemButtonPressed()
  - Opens `AddItemDialog` and awaits a `String?` result (dialog implementation decides payload).
  - If `result` is null the method returns without action. (Add handling to persist new item as needed.)

- Future<void> _onItemTapped(PantryItemModel item)
  - Opens `EditItemDialog` passing the tapped `item`.
  - If `result` is null the method returns without action. (Dialog likely mutates provider via UI.)

- Quantity change callbacks (passed to `PantryItemTile`):
  - incrementQuantity: increments local `item.quantity` and calls `pantry.updateQuantity(item.id, item.quantity)`.
  - decrementQuantity: decrements only when quantity > 0, then calls provider update.
  - changeQuantity: applies when user sets a specific `int newQuantity` (if >= 0) and calls provider update.

Note: the code mutates the `item` object locally then calls provider methods to persist changes. This pattern assumes `PantryItemModel` is mutable and provider's update routines take the id and new quantity.

## UI composition

- Top structure: `Scaffold` containing a `Stack` with a `Material` background and main list.
- The pantry list is wrapped in a `Consumer<PantryProvider>`.
- Each list element is a `PantryItemTile` with callbacks for taps and quantity changes.
- Floating action button uses `SpeedDial` from `flutter_speed_dial` with two `SpeedDialChild` items:
  - QR code scanner icon -> `_onScanButtonPressed`
  - Menu/add icon -> `_onAddItemButtonPressed`

## Dialogs and user flows

1. First-run / missing pantry:
   - On startup (after first frame), if `loadPantryItems()` returned `false` or indicates nothing exists, the code enters a loop showing `NewPantryPrompt` (non-dismissible). The loop ensures the user cannot proceed without creating a pantry name. If they attempt to dismiss or submit an empty name, a SnackBar warns they must create a pantry. After a valid name is returned, `createPantry()` is called and items are reloaded.

2. Adding an item:
   - Tapping the SpeedDial "Add Item" opens `AddItemDialog`. The screen currently only reads the `String?` result and returns; you should add provider calls or logic inside the dialog or here to persist the new item.

3. Scanning an item:
   - The scanner page `ScanPage` is pushed and should return a barcode `String` when done. The code shows a SnackBar with the scanned result. Integrate barcode-handling logic to look up an item or call an API.

4. Editing an item:
   - Tapping an item opens `EditItemDialog(item: item)`. The dialog is expected to handle changes and call provider methods, or return a non-null value to indicate changes. Current code simply discards null results.

## Data flow and state management

- `PantryProvider` is read and observed with `context.read` (for initial load) and `Consumer<PantryProvider>` for rendering. Provider methods used in this file:
  - `loadPantryItems()` -> returns `bool` indicating success
  - `createPantry(String name)` -> creates pantry
  - `updateQuantity(String id, int quantity)` -> persists quantity change
- Local mutations occur on the `PantryItemModel item` (increment/decrement/change), then provider update is invoked. This keeps the UI immediate and persists through provider.

## Contracts (inputs / outputs / error modes)

- Inputs:
  - User interactions: taps, dialogs, scanner results, quantity changes.
  - Provider responses: item lists, loading state, success/failure booleans.
- Outputs:
  - UI: item list, snackbars, dialogs.
  - Provider calls: createPantry, loadPantryItems, updateQuantity.
- Error modes / assumptions:
  - If provider fails to load, user is forced to create a new pantry.
  - Dialogs return `String?` (sometimes empty or null) — code validates non-empty where required.

## Edge cases and considerations

- The `while` loop in `initState` will keep prompting the user until a non-empty pantry name is provided — ensure this is the desired UX (user cannot leave the screen without creating a pantry).
- Mutating `item.quantity` directly is simple but assumes the item is not an immutable value object. Consider cloning or using provider methods that return an updated list to avoid unexpected side effects.
- When provider update fails (e.g., network/database error), there is no error handling or rollback in this file — add error handling and user feedback.
- Scanning returns a raw `String` — the code currently displays it but doesn't handle invalid barcodes or duplicates.

## Accessibility

- Ensure `PantryItemTile` provides semantic labels for screen readers.
- Floating action button icons should have tooltips where possible (SpeedDial children can show labels which is good).

## How to test

- Unit / widget tests to cover:
  - When `PantryProvider` is loading -> `CircularProgressIndicator` is shown.
  - When `PantryProvider` has empty items -> `Text('Empty Pantry')` is shown.
  - When items exist -> `ListView` contains `PantryItemTile` entries.
  - Quantity adjustments call `pantry.updateQuantity` with expected values (mock the provider and verify interactions).
  - `initState` prompting behavior: mock `loadPantryItems()` to return false and assert `NewPantryPrompt` is shown and `createPantry` is called when dialog returns a non-empty name.
  - `_onScanButtonPressed` returns a result and shows a `SnackBar` with the scanned code (wrap `Navigator` in a testable manner or mock the push result).

- Manual test flows:
  - Launch the app with an empty data source and verify the creation prompt cannot be bypassed.
  - Scan a barcode, verify the SnackBar appears and the debug log prints.
  - Edit item and confirm the provider reflects changes.

## Example: Adding provider-side persistence

If your `AddItemDialog` only returns a name or raw value, add code to persist the item after the dialog completes, for example (pseudocode):

- After `final result = await showDialog<String>(...);` do:
  - if (result != null && result.isNotEmpty) pantryProvider.addItemFromName(result);

Or update the dialog to call the provider itself.

## Notes & TODOs (from code)

- TODO: integrate scanned barcode with pantry (lookup/add item by barcode).
- Consider adding better error handling for provider failures.
- Consider moving the pantry creation loop out of UI code into the provider or a dedicated onboarding flow if you want a less-blocking UX.

---

File: `lib/screens/pantry_page.dart`
Purpose: documentation reference for developers and reviewers to understand how `PantryPage` works, its flows, and where to extend behavior.
