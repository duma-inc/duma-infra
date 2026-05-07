document.addEventListener("DOMContentLoaded", function() {
    // Attempt to replace the text inside the kc-header-wrapper to display the alternating colored 'duma' logo
    var header = document.querySelector("#kc-header-wrapper");
    if (header) {
        // Build the logo HTML matching the React Native implementation
        header.innerHTML = '<span style="color: #000000; font-weight: 900; letter-spacing: 4px;">d</span>' +
                           '<span style="color: #FDA91E; font-weight: 900; letter-spacing: 4px;">u</span>' +
                           '<span style="color: #000000; font-weight: 900; letter-spacing: 4px;">m</span>' +
                           '<span style="color: #FDA91E; font-weight: 900; letter-spacing: 4px;">a</span>';
        
        // Increase font size
        header.style.fontSize = '3.5rem';
        header.style.lineHeight = '1.2';
        header.style.textTransform = 'none';
    }
});
