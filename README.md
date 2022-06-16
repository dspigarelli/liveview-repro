# Repro Setup

1. `mix deps.get`
2. `mix phx.server`
3. Navigate to http://localhost:4000/repro

## Issue:
I'm trying to add a class, `border-danger` to the various form elements. I'm choosing to immediately validate with `phx-change="validate"` ()

### Repro Steps
1. See `State` select has no `border-danger` class, as expected:
```html
<select class="" id="my-form_state" name="index[state]"><option value="" selected=""></option><option value="wa">wa</option><option value="ca">ca</option><option value="or">or</option><option value="nv">nv</option></select>
```
![step 1](./step%201.png)
2. Click into the `Name` field and type `t`. Notice that the `State` select now has the `border-danger` class, also as expected:
```html
<select class="border-danger" id="my-form_state" name="index[state]"><option value="" selected=""></option><option value="wa">wa</option><option value="ca">ca</option><option value="or">or</option><option value="nv">nv</option></select>
```
![step 2](./step%202.png)
3. Note the following patch from the server also has `State` with the `border-danger` class:
```json
[
 ...
  "7": "<select class=\"border-danger\" id=\"my-form_state\" name=\"index[state]\"><option selected value=\"\"></option><option value=\"wa\">wa</option><option value=\"ca\">ca</option><option value=\"or\">or</option><option value=\"nv\">nv</option></select>",
  "8": "<span class=\"invalid-feedback\" phx-feedback-for=\"index[state]\">can&#39;t be blank</span>"
...
]
```
4. Now, select `or` in the `State` select. The DOM element continues to have the `border-danger` applied:
```html
<select class="border-danger" id="my-form_state" name="index[state]"><option value="" selected=""></option><option value="wa">wa</option><option value="ca">ca</option><option value="or">or</option><option value="nv">nv</option></select>
```
![step 3](./step%203.png)
However, the patch from the server no longer has `border-danger` being applied to `State`:
```json
[
...
  "7": "<select class=\"\" id=\"my-form_state\" name=\"index[state]\"><option value=\"\"></option><option value=\"wa\">wa</option><option value=\"ca\">ca</option><option selected value=\"or\">or</option><option value=\"nv\">nv</option></select>",
  "8": ""
...
]
```
5. Next, click into `Name` and type another letter. The `border-danger` is no longer applied to `State` in the DOM:
```html
<select class="" id="my-form_state" name="index[state]"><option value=""></option><option value="wa">wa</option><option value="ca">ca</option><option value="or" selected="">or</option><option value="nv">nv</option></select>
```
![step 4](./step%204.png)
And the dom update from the server looks correct:
```json
[
...
  "7": "<select class=\"\" id=\"my-form_state\" name=\"index[state]\"><option value=\"\"></option><option value=\"wa\">wa</option><option value=\"ca\">ca</option><option selected value=\"or\">or</option><option value=\"nv\">nv</option></select>",
  "8": ""
...
]

```
