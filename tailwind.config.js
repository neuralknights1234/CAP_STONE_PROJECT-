/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        // Master Formal Agricultural SaaS Design Tokens - Exact Colors Preserved
        brand: {
          bg: '#F8FAF8',
          surface: '#FFFFFF',
          primary: '#166534', // Deep Forest Green
          'primary-dark': '#14532D',
          secondary: '#16A34A', // Natural Green
          accent: '#15803D',
          'accent-soft': '#DCFCE7', // Light Green
          'nav-active': '#DCFCE7',
          'nav-text': '#166534',
          text: '#1F2937', // Primary text
          'text-secondary': '#64748B', // Secondary text
          border: '#E2E8F0', // Border
          'border-strong': '#CBD5E1', // Strong brutalist border
          warning: '#D97706',
          danger: '#DC2626',
          success: '#15803D',
        },
        agri: {
          dark: '#1F2937',
          forest: '#166534',
          'forest-light': '#16A34A',
          emerald: '#16A34A',
          'emerald-light': '#22C55E',
          sage: '#15803D',
          leaf: '#16A34A',
          mint: '#DCFCE7',
          cream: '#F8FAF8',
          'cream-warm': '#F1F5F1',
          sand: '#E2E8F0',
          harvest: '#D97706',
          earth: '#64748B',
          slate: '#475569',
          muted: '#64748B',
        },
      },
      fontFamily: {
        sans: ['Inter', 'Manrope', 'system-ui', '-apple-system', 'sans-serif'],
        mono: ['ui-monospace', 'SFMono-Regular', 'Menlo', 'Monaco', 'Consolas', 'monospace'],
      },
      boxShadow: {
        'brutal-xs': '1px 1px 0px #CBD5E1',
        'brutal-sm': '2px 2px 0px #CBD5E1',
        'brutal': '3px 3px 0px #94A3B8',
        'brutal-md': '3px 3px 0px #1F2937',
        'brutal-lg': '4px 4px 0px #1F2937',
        'brutal-green': '3px 3px 0px #166534',
        'brutal-dark': '3px 3px 0px #14532D',
        'brutal-forest': '3px 3px 0px #14532D',
        'soft-sm': '2px 2px 0px #CBD5E1',
        'soft-md': '3px 3px 0px #94A3B8',
        'soft-lg': '4px 4px 0px #1F2937',
        'soft-card': '2px 2px 0px #CBD5E1',
        'none': '0 0 #0000',
      },
      borderRadius: {
        'none': '0px',
        'sm': '2px',
        'DEFAULT': '2px',
        'md': '3px',
        'lg': '4px',
        'xl': '4px',
        '2xl': '4px',
        '3xl': '4px',
        'full': '9999px',
      },
      borderWidth: {
        DEFAULT: '1.5px',
        '0': '0',
        '1': '1px',
        '2': '2px',
        '3': '3px',
        '4': '4px',
      },
    },
  },
  plugins: [],
};
