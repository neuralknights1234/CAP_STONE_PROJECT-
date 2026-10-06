import React from 'react';
import { BrowserRouter } from 'react-router-dom';
import { AuthProvider } from './context/AuthContext';
import { AppProvider } from './context/AppContext';
import { ToastProvider } from './context/ToastContext';
import { NotificationProvider } from './context/NotificationContext';
import { I18nProvider } from './i18n/I18nContext';
import { OfflineProvider } from './context/OfflineContext';
import OfflineBanner from './components/common/OfflineBanner';
import AppRoutes from './routes/AppRoutes';
import { normalizeError } from './utils/errorUtils';

class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false, error: null };
  }

  static getDerivedStateFromError(error) {
    return { hasError: true, error };
  }

  componentDidCatch(error, errorInfo) {
    console.error('App Uncaught Error:', error, errorInfo);
  }

  render() {
    if (this.state.hasError) {
      const normalized = normalizeError(this.state.error);
      return (
        <div className="min-h-screen bg-slate-950 text-slate-100 flex items-center justify-center p-6">
          <div className="max-w-md w-full bg-slate-900 border border-rose-500/30 rounded-2xl p-6 shadow-xl text-center space-y-4">
            <div className="w-12 h-12 rounded-xl bg-rose-500/20 text-rose-400 flex items-center justify-center mx-auto text-xl font-bold">
              !
            </div>
            <h2 className="text-lg font-bold text-slate-100">SmartAgri OS Render Notice</h2>
            <div className="space-y-1">
              <p className="text-xs text-slate-300 font-medium leading-relaxed">
                {normalized.message}
              </p>
              <div className="text-[10px] font-mono text-slate-500">
                Code: {normalized.code} • Status: {normalized.status}
              </div>
            </div>
            <button
              onClick={() => {
                localStorage.clear();
                window.location.href = '/dashboard';
              }}
              className="px-4 py-2 text-xs font-semibold rounded-xl bg-emerald-600 hover:bg-emerald-500 text-white transition"
            >
              Reset Session & Open Dashboard
            </button>
          </div>
        </div>
      );
    }
    return this.props.children;
  }
}

export default function App() {
  return (
    <ErrorBoundary>
      <I18nProvider>
        <OfflineProvider>
          <BrowserRouter>
            <AuthProvider>
              <AppProvider>
                <ToastProvider>
                  <NotificationProvider>
                    <OfflineBanner />
                    <AppRoutes />
                  </NotificationProvider>
                </ToastProvider>
              </AppProvider>
            </AuthProvider>
          </BrowserRouter>
        </OfflineProvider>
      </I18nProvider>
    </ErrorBoundary>
  );
}
