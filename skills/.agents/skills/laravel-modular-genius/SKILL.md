---
name: laravel-modular-genius
description: Expert in the "laravel-modular-v5" architecture. Use this skill when the user wants to create new modules, entities, or Filament v5 components within the `modules/{Category}/{Module}` structure. It enforces strict standards for modularity, authentication, and clean code in Filament.
---

# 🚀 Laravel Modular Genius (v5)

Expert specialized in building modular systems with Laravel 13 and Filament v5. This skill ensures that all components follow a strict surgical architecture to maintain portability and high quality.

## 🏗️ Architectural Core

- **Path:** `modules/{Category}/{Module}/`
- **Namespaces:** `Modules\{Category}\{Module}\...`
- **Tooling:** Use `php artisan make:...` for generation, then MANUALLY move files and fix namespaces/imports.

## 🧩 Module Structure Standards

### 1. Models
- Must use `SoftDeletes` and `HasFactory`.
- Logic must be separated into `Concerns/` (Traits):
    - `HasAttributes.php`: For accessors, mutators, and casts.
    - `HasRelations.php`: For all Eloquent relationships.
    - `HasScopes.php`: For query scopes.
- Imports must be sorted alphabetically (ASC).

### 2. Filament v5 Modular Registry
- **NO central registration:** Each module is autonomous.
- **Plugin Strategy:** Create a `{Module}Plugin.php` in the module's `Filament/` folder.
- **Dynamic Boot:** Register the plugin in the module's `ServiceProvider::boot()`:
    ```php
    Filament::serving(function () {
        Filament::getPanel('admin')
            ->plugin({Module}Plugin::make());
    });
    ```

### 3. Resource Organization (The "Standard")
- **Resource:** `Filament/Resources/{Model}Resource.php`
- **Pages:** `Filament/Resources/{PluralModel}/Pages/` (Create, Edit, List, View).
- **Schemas:** `Filament/Resources/{PluralModel}/Schemas/` (Form/Infolist extracted classes).
- **Tables:** `Filament/Resources/{PluralModel}/Tables/` (Table configuration extracted classes).

## 🛠️ Workflows

### Generating a New Module Component
1. Run Artisan command (e.g., `php artisan make:model Product -m`).
2. Create target directory: `mkdir -p modules/{Category}/{Module}/Models`.
3. Move file: `mv app/Models/Product.php modules/{Category}/{Module}/Models/`.
4. Fix Namespace: `Modules\{Category}\{Module}\Models`.
5. Fix Imports: Ensure all `use` blocks are alphabetical and correct.

### Implementing Filament Resources
1. Extract `Table` and `Form` configurations to separate classes in `Tables/` and `Schemas/`.
2. All labels, placeholders, and static text MUST be in **Spanish**.
3. Do NOT include `timestamps` in table listings unless strictly necessary.
4. Ensure `SoftDeletes` support in the Table (Filters, Actions).
