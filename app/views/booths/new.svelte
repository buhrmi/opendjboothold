<script>
    import { useForm } from '@inertiajs/inertia-svelte'
    $: form = useForm('booth', {name: ''})
</script>

<form on:submit|preventDefault={() => $form.post(`/booths`)}>


  <div class="field">
      <label for="name">Name</label>
      <input type="text" id="name" bind:value={$form.name} />
      <span class="error">{$form.errors.name}</span>
    </div>

    <div class="field">
        <button type="submit" class="btn primary">Create</button>
    </div>
</form>