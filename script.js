document.getElementById('dataForm').addEventListener('submit', async function(e) {
    e.preventDefault();

    // Retrieve form data
    const name = document.getElementById('name').value;
    const description = document.getElementById('description').value;

    // Submit form data to the backend
    await fetch('http://127.0.0.1:8000/submit/', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ name: name, description: description })
    });

    // Clear form fields
    document.getElementById('name').value = '';
    document.getElementById('description').value = '';

    // Fetch and display the updated data list
    fetchData();
});

async function fetchData() {
    const response = await fetch('http://127.0.0.1:8000/data/');
    const data = await response.json();

    const dataList = document.getElementById('dataList');
    dataList.innerHTML = ''; // Clear current list

    // Append each item to the list
    data.forEach(item => {
        const listItem = document.createElement('li');
        listItem.textContent = `Name: ${item.name}, Description: ${item.description || 'N/A'}`;
        dataList.appendChild(listItem);
    });
}

// Initial fetch of data when page loads
fetchData();
