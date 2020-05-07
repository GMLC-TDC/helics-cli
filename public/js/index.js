(
    function() {
        let federates = document.querySelector('.federates')

        fetch("/dependency-graph.json")
        .then((resp) => resp.json())
        .then(function(data) {
            data.cores.map(function(core) {
                let li = document.createElement('li');
                li.innerHTML = core.name;
                federates.appendChild(li);
            })
        })
        .catch(function(data) {
        });

    }
)();
