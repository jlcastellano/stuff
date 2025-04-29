// scripts.js

document.addEventListener('DOMContentLoaded', function() {
    // Inicializar los botones de mostrar/ocultar solución
    const solutionButtons = document.querySelectorAll('.mostrar-solucion');
    solutionButtons.forEach(button => {
        button.addEventListener('click', function() {
            const solucion = this.nextElementSibling;
            if (solucion.style.display === 'none' || !solucion.style.display) {
                solucion.style.display = 'block';
                this.textContent = 'Ocultar Solución';
            } else {
                solucion.style.display = 'none';
                this.textContent = 'Mostrar Solución';
            }
        });
    });

    // Agregar funcionalidad para copiar código
    document.querySelectorAll('.code-block').forEach(block => {
        const copyButton = document.createElement('button');
        copyButton.className = 'copy-button';
        copyButton.textContent = 'Copiar';
        
        copyButton.addEventListener('click', function() {
            const code = block.querySelector('pre').textContent;
            navigator.clipboard.writeText(code).then(() => {
                copyButton.textContent = '¡Copiado!';
                setTimeout(() => {
                    copyButton.textContent = 'Copiar';
                }, 2000);
            });
        });

        block.insertBefore(copyButton, block.firstChild);
    });

    // Resaltar sección activa en el sidebar
    function highlightCurrentSection() {
        const currentPath = window.location.pathname;
        const sidebarLinks = document.querySelectorAll('.sidebar-nav a');
        
        sidebarLinks.forEach(link => {
            if (link.getAttribute('href') === currentPath) {
                link.classList.add('active');
            }
        });
    }

    // Manejar navegación entre capítulos
    const prevChapterBtn = document.querySelector('.prev-chapter');
    const nextChapterBtn = document.querySelector('.next-chapter');

    if (prevChapterBtn) {
        prevChapterBtn.addEventListener('click', function(e) {
            e.preventDefault();
            window.location.href = this.getAttribute('href');
        });
    }

    if (nextChapterBtn) {
        nextChapterBtn.addEventListener('click', function(e) {
            e.preventDefault();
            window.location.href = this.getAttribute('href');
        });
    }

    // Función para manejar el scroll suave a las secciones
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            const targetId = this.getAttribute('href');
            const targetElement = document.querySelector(targetId);
            
            if (targetElement) {
                targetElement.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });

    // Inicializar tooltips si existen
    const tooltips = document.querySelectorAll('[data-tooltip]');
    tooltips.forEach(tooltip => {
        tooltip.addEventListener('mouseover', function(e) {
            const tooltipText = this.getAttribute('data-tooltip');
            const tooltipElement = document.createElement('div');
            tooltipElement.className = 'tooltip';
            tooltipElement.textContent = tooltipText;
            document.body.appendChild(tooltipElement);
            
            const rect = this.getBoundingClientRect();
            tooltipElement.style.top = rect.bottom + 'px';
            tooltipElement.style.left = rect.left + 'px';
        });

        tooltip.addEventListener('mouseout', function() {
            const tooltips = document.querySelectorAll('.tooltip');
            tooltips.forEach(t => t.remove());
        });
    });

    // Llamar a las funciones de inicialización
    highlightCurrentSection();
});