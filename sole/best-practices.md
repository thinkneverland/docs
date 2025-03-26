# Best Practices

This guide outlines best practices for using Sole effectively in your Laravel applications.

## Component Organization

### Directory Structure

```
resources/
└── views/
    └── components/
        ├── common/           # Reusable components
        │   ├── button.sole
        │   └── input.sole
        ├── forms/           # Form-related components
        │   ├── login.sole
        │   └── register.sole
        └── layouts/         # Layout components
            ├── header.sole
            └── footer.sole
```

### Naming Conventions

- Use kebab-case for file names: `user-profile.sole`
- Use PascalCase for component classes: `UserProfile`
- Use descriptive, action-oriented names for methods: `handleSubmit`, `validateInput`

## Component Structure

### Template Section

```php
<template>
    <!-- Keep templates clean and semantic -->
    <div class="user-profile">
        <header class="user-profile__header">
            <h1>{{ $state->user->name }}</h1>
        </header>
        
        <main class="user-profile__content">
            <!-- Content here -->
        </main>
    </div>
</template>
```

### PHP Section

```php
<?php
// Initialize state in mount()
function mount() {
    $state->user = null;
    $state->loading = false;
    $state->error = null;
}

// Use descriptive method names
function handleUserUpdate() {
    $state->loading = true;
    try {
        // Update logic
    } catch (Exception $e) {
        $state->error = $e->getMessage();
    } finally {
        $state->loading = false;
    }
}
?>
```

### Style Section

```html
<style scoped>
/* Use BEM naming convention */
.user-profile {
    padding: 1rem;
}

.user-profile__header {
    margin-bottom: 1rem;
}

.user-profile__content {
    display: grid;
    gap: 1rem;
}
</style>
```

## State Management

### State Initialization

```php
function mount() {
    // Initialize all state properties
    $state->data = [];
    $state->loading = false;
    $state->error = null;
    
    // Use computed properties for derived values
    $this->defineComputed('total', function() {
        return array_sum(array_column($state->data, 'amount'));
    }, ['data']);
}
```

### State Updates

```php
// Use methods for state updates
function updateUser($data) {
    $state->loading = true;
    try {
        $state->user = User::update($data);
        $this->notify('success', 'User updated successfully');
    } catch (Exception $e) {
        $state->error = $e->getMessage();
    } finally {
        $state->loading = false;
    }
}
```

## Event Handling

### Event Methods

```php
// Use descriptive event handler names
function handleFormSubmit($event) {
    $event->preventDefault();
    $this->validateForm();
    $this->submitForm();
}

// Separate validation logic
function validateForm() {
    $errors = [];
    if (empty($state->email)) {
        $errors['email'] = 'Email is required';
    }
    if (!filter_var($state->email, FILTER_VALIDATE_EMAIL)) {
        $errors['email'] = 'Invalid email format';
    }
    $state->errors = $errors;
}
```

## File Uploads

### Upload Handling

```php
function handleFileUpload($file) {
    // Validate file
    if (!$this->validateFile($file)) {
        return;
    }
    
    // Show progress
    $state->uploading = true;
    $state->progress = 0;
    
    // Handle upload
    $this->upload($file, function($progress) {
        $state->progress = $progress;
    })->then(function($response) {
        $state->uploading = false;
        $this->notify('success', 'File uploaded successfully');
    })->catch(function($error) {
        $state->uploading = false;
        $state->error = $error->getMessage();
    });
}
```

## Real-time Updates

### Polling Configuration

```php
function mount() {
    // Use appropriate polling intervals
    $this->refresh('30s');
    
    // Initialize state
    $state->items = [];
    $state->lastUpdate = null;
}

function refresh() {
    try {
        $state->items = Item::latest()->get();
        $state->lastUpdate = now();
    } catch (Exception $e) {
        $state->error = $e->getMessage();
    }
}
```

## Accessibility

### ARIA Implementation

```php
<template>
    <div role="dialog" aria-labelledby="dialog-title">
        <h2 id="dialog-title">{{ $state->title }}</h2>
        <div aria-live="polite">
            {{ $state->message }}
        </div>
        <button 
            aria-label="Close dialog"
            click="closeDialog"
        >
            ×
        </button>
    </div>
</template>
```

### Keyboard Navigation

```php
<template>
    <div tabindex="0" keydown="handleKeyPress">
        <!-- Content -->
    </div>
</template>

<?php
function handleKeyPress($event) {
    switch ($event->key) {
        case 'Escape':
            $this->closeDialog();
            break;
        case 'Enter':
            $this->submitForm();
            break;
    }
}
?>
```

## Performance

### Lazy Loading

```php
<template>
    <div>
        <div lazy-load="heavy-content">
            <!-- Heavy content here -->
        </div>
    </div>
</template>
```

### Caching

```php
function getData() {
    return cache()->remember('key', 3600, function() {
        return Item::with('relationships')->get();
    });
}
```

## Security

### Input Validation

```php
function validateInput($data) {
    $validator = validator($data, [
        'email' => 'required|email',
        'password' => 'required|min:8'
    ]);
    
    if ($validator->fails()) {
        $state->errors = $validator->errors();
        return false;
    }
    
    return true;
}
```

### CSRF Protection

```php
<template>
    <form csrf>
        <!-- Form content -->
    </form>
</template>
```

## Testing

### Component Testing

```php
class UserProfileTest extends TestCase
{
    public function test_user_profile_loads()
    {
        $component = $this->renderComponent('user-profile', [
            'userId' => 1
        ]);
        
        $component->assertSee('User Profile');
        $component->assertStateEquals('loading', false);
    }
}
```

### Event Testing

```php
public function test_form_submission()
{
    $component = $this->renderComponent('login-form');
    
    $component->setState('email', 'test@example.com');
    $component->setState('password', 'password');
    
    $component->click('button[type="submit"]');
    
    $component->assertStateEquals('submitted', true);
}
```

## Next Steps

- Review [Advanced Features](advanced-features.md)
- Check out [Examples](examples.md)
- Visit our [GitBook documentation](https://thinkneverland.gitbook.io/sole/) for more resources
