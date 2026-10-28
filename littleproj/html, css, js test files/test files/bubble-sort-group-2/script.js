const container = document.getElementById('sort-container');

    let numbers = Array.from({ length: 10 }, (_, i) => i + 1);
    shuffleArray(numbers);
    renderBoxes(numbers);

    function shuffleArray(arr) {
      for (let i = arr.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [arr[i], arr[j]] = [arr[j], arr[i]];
      }
    }

    function renderBoxes(arr, highlightIndices = [], sortedIndex = null) {
      container.innerHTML = '';
      arr.forEach((num, i) => {
        const box = document.createElement('div');
        box.classList.add('number-box');
        box.textContent = num;

        if (highlightIndices.includes(i)) {
          box.classList.add('highlight');
        }

        if (sortedIndex !== null && i >= sortedIndex) {
          box.classList.add('sorted');
        }

        container.appendChild(box);
      });
    }

    async function startBubbleSort() {
      let arr = [...numbers];
      let n = arr.length;

      for (let i = 0; i < n - 1; i++) {
        for (let j = 0; j < n - i - 1; j++) {
          renderBoxes(arr, [j, j + 1], n - i);
          await sleep(400);

          if (arr[j] > arr[j + 1]) {
            [arr[j], arr[j + 1]] = [arr[j + 1], arr[j]];
            renderBoxes(arr, [j, j + 1], n - i);
            await sleep(400);
          }
        }
      }

      renderBoxes(arr, [], 0);
    }

    function sleep(ms) {
      return new Promise(resolve => setTimeout(resolve, ms));
    }