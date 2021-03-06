#-------------------------------------------------
#
# Qmake project file for gqrx
#
#-------------------------------------------------

QT       += core gui svg
TEMPLATE = app

macx {
    TARGET = Gqrx
    ICON = icons/scope.icns
} else {
    TARGET = gqrx
}

linux-g++|linux-g++-64 {
    # Comment out to use gnuradio-audio (wont work on Linux)
    AUDIO_BACKEND = pulse
}

RESOURCES += icons.qrc

#CONFIG += debug

# disable debug messages in release
CONFIG(debug, debug|release) {
    # Use for valgrind
    #QMAKE_CFLAGS_DEBUG += '-g -O0'

    # Define version string (see below for releases)
    VER = $$system(git describe --abbrev=8)
} else {
    DEFINES += QT_NO_DEBUG
    DEFINES += QT_NO_DEBUG_OUTPUT
    VER = 0.0

    # Release binaries with gr bundled
    # QMAKE_RPATH & co won't work with origin
    ## QMAKE_LFLAGS += '-Wl,-rpath,\'\$$ORIGIN/lib\''
}

# Tip from: http://www.qtcentre.org/wiki/index.php?title=Version_numbering_using_QMake
VERSTR = '\\"$${VER}\\"'          # place quotes around the version string
DEFINES += VERSION=\"$${VERSTR}\" # create a VERSION macro containing the version string


SOURCES += \
    applications/gqrx/main.cpp \
    applications/gqrx/mainwindow.cpp \
    applications/gqrx/receiver.cpp \
    dsp/rx_fft.cpp \
    dsp/rx_filter.cpp \
    dsp/rx_demod_fm.cpp \
    dsp/rx_meter.cpp \
    dsp/rx_demod_am.cpp \
    dsp/sniffer_f.cpp \
    dsp/afsk1200/costabf.c \
    dsp/afsk1200/cafsk12.cpp \
    dsp/agc_impl.cpp \
    dsp/correct_iq_cc.cpp \
    dsp/lpf.cpp \
    dsp/rx_agc_xx.cpp \
    dsp/rx_noise_blanker_cc.cpp \
    dsp/resampler_xx.cpp \
    dsp/stereo_demod.cpp \
    qtgui/dockrxopt.cpp \
    qtgui/freqctrl.cpp \
    qtgui/meter.cpp \
    qtgui/plotter.cpp \
    qtgui/ioconfig.cpp \
    qtgui/dockinputctl.cpp \
    qtgui/dockaudio.cpp \
    qtgui/dockfft.cpp \
    qtgui/dockiqplayer.cpp \
    qtgui/afsk1200win.cpp \
    qtgui/bpsk1000win.cpp \
    qtgui/arissattlm.cpp \
    qtgui/demod-options.cpp \
    receivers/receiver_base.cpp \
    receivers/nbrx.cpp \
    tlm/arissat/scale_therm.c \
    tlm/arissat/scale_psu.c \
    tlm/arissat/scale_ppt.c \
    receivers/wfmrx.cpp

HEADERS += \
    applications/gqrx/mainwindow.h \
    applications/gqrx/receiver.h \
    applications/gqrx/gqrx.h \
    dsp/rx_fft.h \
    dsp/rx_filter.h \
    dsp/rx_demod_fm.h \
    dsp/rx_meter.h \
    dsp/rx_demod_am.h \
    dsp/sniffer_f.h \
    dsp/afsk1200/filter-i386.h \
    dsp/afsk1200/filter.h \
    dsp/afsk1200/cafsk12.h \
    dsp/agc_impl.h \
    dsp/correct_iq_cc.h \
    dsp/lpf.h \
    dsp/resampler_xx.h \
    dsp/rx_agc_xx.h \
    dsp/rx_noise_blanker_cc.h \
    dsp/stereo_demod.h \
    qtgui/freqctrl.h \
    qtgui/meter.h \
    qtgui/plotter.h \
    qtgui/ioconfig.h \
    qtgui/dockinputctl.h \
    qtgui/dockaudio.h \
    qtgui/dockfft.h \
    qtgui/dockrxopt.h \
    qtgui/dockiqplayer.h \
    qtgui/afsk1200win.h \
    qtgui/bpsk1000win.h \
    qtgui/arissattlm.h \
    qtgui/demod-options.h \
    receivers/receiver_base.h \
    receivers/nbrx.h \
    tlm/arissat/ss_types_common.h \
    tlm/arissat/ss_stdint.h \
    tlm/arissat/scale_therm.h \
    tlm/arissat/scale_psu.h \
    tlm/arissat/scale_ppt.h \
    receivers/wfmrx.h

FORMS += \
    applications/gqrx/mainwindow.ui \
    qtgui/dockrxopt.ui \
    qtgui/ioconfig.ui \
    qtgui/dockinputctl.ui \
    qtgui/dockaudio.ui \
    qtgui/dockfft.ui \
    qtgui/dockiqplayer.ui \
    qtgui/afsk1200win.ui \
    qtgui/bpsk1000win.ui \
    qtgui/arissattlm.ui \
    qtgui/demod-options.ui


# Use pulseaudio (ps: could use equals? undocumented)
contains(AUDIO_BACKEND, pulse): {
    HEADERS += \
        pulseaudio/pa_device_list.h \
        pulseaudio/pa_sink.h \
        pulseaudio/pa_source.h
    SOURCES += \
        pulseaudio/pa_device_list.cc \
        pulseaudio/pa_sink.cc \
        pulseaudio/pa_source.cc
    DEFINES += WITH_PULSEAUDIO
}

# dependencies via pkg-config
# FIXME: check for version?
unix {
    CONFIG += link_pkgconfig

    contains(AUDIO_BACKEND, pulse): {
        PKGCONFIG += libpulse libpulse-simple
    } else {
        PKGCONFIG += gnuradio-core gnuradio-audio
    }
    PKGCONFIG += gnuradio-osmosdr
}

unix:!macx {
    LIBS += -lboost_system -lboost_program_options
#    LIBS += -lrt  # need to include on some distros
}

macx-g++ {
     LIBS += -lboost_system-mt -lboost_program_options-mt
#    INCLUDEPATH += /usr/local/include
#    INCLUDEPATH += /usr/local/include/gnuradio
#    INCLUDEPATH += /usr/local/include/osmosdr
#    INCLUDEPATH += /opt/local/include
}

OTHER_FILES += \
    README \
    COPYING

