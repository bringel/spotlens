# Record

This extension lets you use Mousetrap to record keyboard sequences and play them back:

```html
<button onclick="recordSequence()">Record</button>
<button onclick="stopRecord()">Stop</button>

<script>
    function recordSequence() {
        Mousetrap.record(function(sequence) {
            // sequence is an array like ['ctrl+k', 'c'] or null if stopRecord() has been called
            if (sequence !== null) {
                alert('You pressed: ' + sequence.join(' '));
            } else {
                alert('Recording of sequence has been stopped');
            }
        });
    }

    function stopRecord() {
        Mousetrap.stopRecord();
    }
</script>
```
